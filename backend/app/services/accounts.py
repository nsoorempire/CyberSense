from datetime import datetime, timedelta, timezone
from typing import Optional
from uuid import UUID

from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.errors import AppError
from app.core.security import (
    access_token,
    generate_otp,
    hash_otp,
    hash_password,
    hash_token,
    mask_phone,
    new_token,
    normalize_phone,
    otp_matches,
    validate_password,
    verify_password,
)
from app.models import LoginActivity, OtpVerification, PasswordReset, Permission, Role, RolePermission, User, UserRole, UserSession
from app.schemas.common import (
    ActivityPublic,
    ChallengeResponse,
    SessionPublic,
    TokenResponse,
    UserPublic,
    UserStats,
)
from app.services.otp_provider import MockOtpSender, OtpSender

USER_PERMISSIONS = ["dashboard.view", "profile.read", "profile.update", "activity.read", "sessions.manage"]
ADMIN_PERMISSIONS = USER_PERMISSIONS + ["activity.read_all", "users.read", "users.update"]


def now() -> datetime:
    return datetime.now(timezone.utc)


def role_name(user: User) -> str:
    names = {role.name for role in user.roles}
    return "admin" if "admin" in names else "user"


def has_permission(user: User, code: str) -> bool:
    return any(permission.code == code for role in user.roles for permission in role.permissions)


def to_public(user: User) -> UserPublic:
    return UserPublic(
        id=user.id,
        full_name=user.full_name,
        email=user.email,
        country_code=user.country_code,
        phone_national=user.phone_national,
        phone_e164=user.phone_e164,
        role=role_name(user),
        is_active=user.is_active,
        is_banned=user.is_banned,
        is_verified=user.is_verified,
        created_at=user.created_at,
        last_login_at=user.last_login_at,
    )


class AccountService:
    def __init__(self, db: Session, sender: OtpSender) -> None:
        self.db = db
        self.sender = sender

    def register(self, full_name: str, email: str, country_code: str, phone: str, password: str) -> ChallengeResponse:
        validate_password(password)
        dial, national, e164 = normalize_phone(country_code, phone)
        normalized = email.strip().lower()
        if self._active_user(email=normalized):
            raise AppError("EMAIL_IN_USE", "An account with this email already exists", 409)
        if self._active_user(phone=e164):
            raise AppError("PHONE_IN_USE", "An account with this phone number already exists", 409)
        return self._issue_otp(
            phone=e164,
            purpose="signup",
            pending={
                "full_name": full_name.strip(),
                "email": normalized,
                "country_code": dial,
                "phone_national": national,
                "phone_e164": e164,
                "password_hash": hash_password(password),
            },
        )

    def login(self, email: str, password: str, device_name: str, ip_address: str, user_agent: str) -> ChallengeResponse:
        normalized = email.strip().lower()
        user = self._active_user(email=normalized)
        if user is None or not verify_password(password, user.password_hash):
            self._activity(email=normalized, user=user, success=False, device_name=device_name, ip_address=ip_address, user_agent=user_agent, reason="INVALID_CREDENTIALS")
            self.db.commit()
            raise AppError("INVALID_CREDENTIALS", "Email or password is incorrect", 401)
        self._ensure_can_sign_in(user, device_name, ip_address, user_agent)
        return self._issue_otp(phone=user.phone_e164, purpose="login", user_id=user.id)

    def forgot_password(self, country_code: str, phone: str) -> ChallengeResponse:
        _, _, e164 = normalize_phone(country_code, phone)
        user = self._active_user(phone=e164)
        if user is None:
            raise AppError("PHONE_NOT_FOUND", "No account uses this WhatsApp number", 404)
        if user.is_banned:
            raise AppError("ACCOUNT_BANNED", "This account is banned", 403)
        return self._issue_otp(phone=e164, purpose="reset", user_id=user.id)

    def resend(self, challenge_id: UUID) -> ChallengeResponse:
        otp = self.db.get(OtpVerification, challenge_id)
        if otp is None or otp.consumed_at is not None:
            raise AppError("OTP_EXPIRED", "This code has expired", 400)
        if otp.sent_at + timedelta(seconds=settings.otp_resend_seconds) > now():
            raise AppError("RESEND_TOO_SOON", "Please wait before requesting another code", 429)
        code = generate_otp()
        otp.code_hash = hash_otp(code)
        otp.attempts = 0
        otp.sent_at = now()
        otp.expires_at = now() + timedelta(seconds=settings.otp_ttl_seconds)
        self._dispatch(otp.phone_e164, code)
        self.db.commit()
        return self._challenge(otp, code)

    def verify(self, challenge_id: UUID, code: str, device_name: str, ip_address: str, user_agent: str) -> TokenResponse:
        otp = self.db.get(OtpVerification, challenge_id)
        if otp is None or otp.consumed_at is not None:
            raise AppError("INVALID_OTP", "That code is not correct", 400)
        if otp.expires_at < now():
            raise AppError("OTP_EXPIRED", "This code has expired", 400)
        if otp.attempts >= otp.max_attempts:
            raise AppError("TOO_MANY_ATTEMPTS", "Too many attempts. Request a new code.", 429, {"attempts_left": 0})
        if not otp_matches(code.strip(), otp.code_hash):
            otp.attempts += 1
            self.db.commit()
            left = otp.max_attempts - otp.attempts
            if left <= 0:
                raise AppError("TOO_MANY_ATTEMPTS", "Too many attempts. Request a new code.", 429, {"attempts_left": 0})
            raise AppError("INVALID_OTP", "That code is not correct", 400, {"attempts_left": left})
        otp.consumed_at = now()
        if otp.purpose == "reset":
            user = self.db.get(User, otp.user_id)
            if user is None:
                raise AppError("PHONE_NOT_FOUND", "No account uses this WhatsApp number", 404)
            raw = new_token()
            self.db.add(
                PasswordReset(
                    user_id=user.id,
                    otp_id=otp.id,
                    token_hash=hash_token(raw),
                    expires_at=now() + timedelta(minutes=10),
                )
            )
            self.db.commit()
            return TokenResponse(reset_token=raw)
        user = self._user_from_otp(otp)
        user.last_login_at = now()
        user.is_verified = True
        token = self._open_session(user, device_name, ip_address, user_agent)
        self._activity(email=user.email, user=user, success=True, device_name=device_name, ip_address=ip_address, user_agent=user_agent)
        self.db.commit()
        return token

    def reset_password(self, reset_token: str, new_password: str) -> None:
        validate_password(new_password)
        row = self.db.scalar(select(PasswordReset).where(PasswordReset.token_hash == hash_token(reset_token)))
        if row is None or row.completed_at is not None or row.expires_at < now():
            raise AppError("OTP_EXPIRED", "This reset link has expired", 400)
        user = self.db.get(User, row.user_id)
        if user is None or user.deleted_at is not None:
            raise AppError("PHONE_NOT_FOUND", "No account uses this WhatsApp number", 404)
        user.password_hash = hash_password(new_password)
        user.updated_at = now()
        row.completed_at = now()
        self._revoke_all(user.id)
        self.db.commit()

    def refresh(self, refresh_token: str, device_name: str, ip_address: str) -> TokenResponse:
        session = self.db.scalar(select(UserSession).where(UserSession.refresh_token_hash == hash_token(refresh_token)))
        if session is None or session.revoked_at is not None or session.expires_at < now():
            raise AppError("UNAUTHORIZED", "Session is not valid", 401)
        user = self.db.get(User, session.user_id)
        if user is None or user.deleted_at is not None or user.is_banned or not user.is_active:
            raise AppError("UNAUTHORIZED", "Session is not valid", 401)
        raw = new_token()
        session.refresh_token_hash = hash_token(raw)
        session.last_used_at = now()
        session.expires_at = now() + timedelta(days=settings.refresh_token_days)
        if device_name:
            session.device_name = device_name[:160]
        if ip_address:
            session.ip_address = ip_address[:64]
        self.db.commit()
        return self._tokens(user, session, raw)

    def logout(self, session_id: UUID) -> None:
        session = self.db.get(UserSession, session_id)
        if session and session.revoked_at is None:
            session.revoked_at = now()
            self.db.commit()

    def update_profile(self, user: User, full_name: str, country_code: str, phone: str) -> UserPublic:
        dial, national, e164 = normalize_phone(country_code, phone)
        existing = self._active_user(phone=e164)
        if existing and existing.id != user.id:
            raise AppError("PHONE_IN_USE", "An account with this phone number already exists", 409)
        user.full_name = full_name.strip()
        user.country_code = dial
        user.phone_national = national
        user.phone_e164 = e164
        user.updated_at = now()
        self.db.commit()
        self.db.refresh(user)
        return to_public(user)

    def change_password(self, user: User, current_password: str, new_password: str) -> None:
        validate_password(new_password)
        if not verify_password(current_password, user.password_hash):
            raise AppError("INVALID_CREDENTIALS", "Email or password is incorrect", 401)
        user.password_hash = hash_password(new_password)
        user.updated_at = now()
        self.db.commit()

    def stats(self) -> UserStats:
        def count(*filters: object) -> int:
            stmt = select(func.count()).select_from(User).where(User.deleted_at.is_(None), *filters)
            return int(self.db.scalar(stmt) or 0)

        return UserStats(
            total=count(),
            active=count(User.is_active.is_(True), User.is_banned.is_(False)),
            banned=count(User.is_banned.is_(True)),
            inactive=count(User.is_active.is_(False), User.is_banned.is_(False)),
        )

    def list_users(self, query: str, status: str) -> list[UserPublic]:
        stmt = select(User).where(User.deleted_at.is_(None))
        if status == "active":
            stmt = stmt.where(User.is_active.is_(True), User.is_banned.is_(False))
        elif status == "banned":
            stmt = stmt.where(User.is_banned.is_(True))
        elif status == "inactive":
            stmt = stmt.where(User.is_active.is_(False), User.is_banned.is_(False))
        if query.strip():
            like = f"%{query.strip().lower()}%"
            stmt = stmt.where(or_(func.lower(User.full_name).like(like), func.lower(User.email).like(like), User.phone_e164.like(f"%{query.strip()}%")))
        stmt = stmt.order_by(User.created_at.desc()).limit(100)
        return [to_public(user) for user in self.db.scalars(stmt)]

    def update_user(self, actor: User, user_id: UUID, role: Optional[str], is_active: Optional[bool], is_banned: Optional[bool], deleted: bool) -> UserPublic:
        user = self.db.get(User, user_id)
        if user is None or user.deleted_at is not None:
            raise AppError("UNKNOWN", "Account was not found", 404)
        if actor.id == user.id and (role or is_active is not None or is_banned is not None or deleted):
            raise AppError("FORBIDDEN", "You cannot change your own access", 403)
        if deleted:
            user.deleted_at = now()
            user.is_active = False
            self._revoke_all(user.id)
        else:
            if role in {"user", "admin"} and role != role_name(user):
                self._set_role(user, role)
            if is_banned is not None:
                user.is_banned = is_banned
                if is_banned:
                    user.is_active = False
                    self._revoke_all(user.id)
                elif not user.is_active:
                    user.is_active = True
            if is_active is not None and not user.is_banned:
                user.is_active = is_active
                if not is_active:
                    self._revoke_all(user.id)
        user.updated_at = now()
        self.db.commit()
        self.db.refresh(user)
        return to_public(user)

    def activity_for(self, actor: User) -> list[ActivityPublic]:
        stmt = select(LoginActivity, User.full_name).join(User, User.id == LoginActivity.user_id, isouter=True).order_by(LoginActivity.created_at.desc()).limit(50)
        if not has_permission(actor, "activity.read_all"):
            stmt = stmt.where(LoginActivity.user_id == actor.id)
        rows = self.db.execute(stmt).all()
        return [
            ActivityPublic(
                id=activity.id,
                user_name=name,
                email=activity.email,
                success=activity.success,
                device_name=activity.device_name,
                ip_address=activity.ip_address,
                failure_reason=activity.failure_reason,
                created_at=activity.created_at,
            )
            for activity, name in rows
        ]

    def sessions_for(self, user: User, current_session: UUID) -> list[SessionPublic]:
        rows = self.db.scalars(select(UserSession).where(UserSession.user_id == user.id, UserSession.revoked_at.is_(None)).order_by(UserSession.last_used_at.desc()))
        return [
            SessionPublic(
                id=session.id,
                device_name=session.device_name,
                ip_address=session.ip_address,
                created_at=session.created_at,
                last_used_at=session.last_used_at,
                current=session.id == current_session,
            )
            for session in rows
        ]

    def revoke_session(self, user: User, session_id: UUID) -> None:
        session = self.db.get(UserSession, session_id)
        if session is None or session.user_id != user.id:
            raise AppError("UNKNOWN", "Session was not found", 404)
        session.revoked_at = now()
        self.db.commit()

    def revoke_all(self, user_id: UUID) -> None:
        self._revoke_all(user_id)
        self.db.commit()

    def _issue_otp(self, phone: str, purpose: str, user_id: Optional[UUID] = None, pending: Optional[dict] = None) -> ChallengeResponse:
        for existing in self.db.scalars(select(OtpVerification).where(OtpVerification.phone_e164 == phone, OtpVerification.purpose == purpose, OtpVerification.consumed_at.is_(None))):
            existing.consumed_at = now()
        code = generate_otp()
        otp = OtpVerification(
            user_id=user_id,
            phone_e164=phone,
            purpose=purpose,
            code_hash=hash_otp(code),
            attempts=0,
            max_attempts=settings.otp_max_attempts,
            pending_payload=pending,
            sent_at=now(),
            expires_at=now() + timedelta(seconds=settings.otp_ttl_seconds),
        )
        self.db.add(otp)
        self.db.flush()
        try:
            self._dispatch(phone, code)
        except AppError:
            self.db.rollback()
            raise
        self.db.commit()
        return self._challenge(otp, code)

    def _dispatch(self, phone: str, code: str) -> None:
        self.sender.send(phone, code)

    def _challenge(self, otp: OtpVerification, code: str) -> ChallengeResponse:
        expose = settings.debug and settings.expose_dev_otp and settings.otp_provider == "mock"
        return ChallengeResponse(
            challenge_id=otp.id,
            masked_phone=mask_phone(otp.phone_e164),
            purpose=otp.purpose,
            expires_in=settings.otp_ttl_seconds,
            resend_in=settings.otp_resend_seconds,
            attempts_left=otp.max_attempts - otp.attempts,
            dev_code=code if expose else None,
        )

    def _user_from_otp(self, otp: OtpVerification) -> User:
        if otp.purpose == "signup":
            pending = otp.pending_payload or {}
            user = User(
                full_name=pending["full_name"],
                email=pending["email"],
                country_code=pending["country_code"],
                phone_national=pending["phone_national"],
                phone_e164=pending["phone_e164"],
                password_hash=pending["password_hash"],
                is_active=True,
                is_banned=False,
                is_verified=True,
            )
            self.db.add(user)
            self.db.flush()
            self._set_role(user, "user")
            return user
        user = self.db.get(User, otp.user_id)
        if user is None or user.deleted_at is not None:
            raise AppError("UNAUTHORIZED", "Session is not valid", 401)
        self._ensure_can_sign_in(user, "", "", "")
        return user

    def _open_session(self, user: User, device_name: str, ip_address: str, user_agent: str) -> TokenResponse:
        raw = new_token()
        session = UserSession(
            user_id=user.id,
            refresh_token_hash=hash_token(raw),
            device_name=(device_name or "Unknown device")[:160],
            ip_address=(ip_address or "")[:64],
            user_agent=(user_agent or "")[:255],
            last_used_at=now(),
            expires_at=now() + timedelta(days=settings.refresh_token_days),
        )
        self.db.add(session)
        self.db.flush()
        return self._tokens(user, session, raw)

    def _tokens(self, user: User, session: UserSession, refresh: str) -> TokenResponse:
        return TokenResponse(
            access_token=access_token(user.id, session.id, role_name(user)),
            refresh_token=refresh,
            expires_in=settings.access_token_minutes * 60,
            user=to_public(user),
        )

    def _ensure_can_sign_in(self, user: User, device_name: str, ip_address: str, user_agent: str) -> None:
        if user.is_banned:
            self._activity(email=user.email, user=user, success=False, device_name=device_name, ip_address=ip_address, user_agent=user_agent, reason="ACCOUNT_BANNED")
            self.db.commit()
            raise AppError("ACCOUNT_BANNED", "This account is banned", 403)
        if not user.is_active:
            self._activity(email=user.email, user=user, success=False, device_name=device_name, ip_address=ip_address, user_agent=user_agent, reason="ACCOUNT_INACTIVE")
            self.db.commit()
            raise AppError("ACCOUNT_INACTIVE", "This account is inactive", 403)

    def _activity(self, email: str, user: Optional[User], success: bool, device_name: str, ip_address: str, user_agent: str, reason: Optional[str] = None) -> None:
        self.db.add(
            LoginActivity(
                user_id=None if user is None else user.id,
                email=email,
                success=success,
                device_name=(device_name or "")[:160],
                ip_address=(ip_address or "")[:64],
                user_agent=(user_agent or "")[:255],
                failure_reason=reason,
            )
        )

    def _active_user(self, email: Optional[str] = None, phone: Optional[str] = None) -> Optional[User]:
        stmt = select(User).where(User.deleted_at.is_(None))
        if email is not None:
            stmt = stmt.where(func.lower(User.email) == email.lower())
        if phone is not None:
            stmt = stmt.where(User.phone_e164 == phone)
        return self.db.scalar(stmt)

    def _set_role(self, user: User, name: str) -> None:
        role = self.db.scalar(select(Role).where(Role.name == name))
        if role is None:
            raise AppError("UNKNOWN", "Role was not found", 500)
        for link in self.db.scalars(select(UserRole).where(UserRole.user_id == user.id)):
            self.db.delete(link)
        self.db.flush()
        self.db.add(UserRole(user_id=user.id, role_id=role.id))
        self.db.flush()
        self.db.expire(user, ["roles"])

    def _revoke_all(self, user_id: UUID) -> None:
        for session in self.db.scalars(select(UserSession).where(UserSession.user_id == user_id, UserSession.revoked_at.is_(None))):
            session.revoked_at = now()


def seed(db: Session) -> None:
    permissions = {code: Permission(code=code, description=code) for code in ADMIN_PERMISSIONS}
    for code, permission in permissions.items():
        existing = db.scalar(select(Permission).where(Permission.code == code))
        if existing is None:
            db.add(permission)
        else:
            permissions[code] = existing
    db.flush()

    def ensure_role(name: str, codes: list[str]) -> Role:
        role = db.scalar(select(Role).where(Role.name == name))
        if role is None:
            role = Role(name=name, description=f"{name} access")
            db.add(role)
            db.flush()
        current = {item.permission_id for item in db.scalars(select(RolePermission).where(RolePermission.role_id == role.id))}
        for code in codes:
            permission = permissions[code]
            if permission.id not in current:
                db.add(RolePermission(role_id=role.id, permission_id=permission.id))
        return role

    ensure_role("user", USER_PERMISSIONS)
    ensure_role("admin", ADMIN_PERMISSIONS)
    db.flush()

    service = AccountService(db, sender=MockOtpSender())
    samples = [
        ("Cyber Sense Admin", "admin@cybersense.app", "500000001", "Admin#2026", "admin", True, False),
        ("Lina Haddad", "user@cybersense.app", "500000002", "User#2026", "user", True, False),
        ("Sara Ahmed", "sara@cybersense.app", "500000003", "Demo#2026", "user", True, False),
        ("Omar Hassan", "omar@cybersense.app", "500000004", "Demo#2026", "user", True, True),
        ("Maya Khalid", "maya@cybersense.app", "500000005", "Demo#2026", "user", False, False),
        ("Yusuf Nasser", "yusuf@cybersense.app", "500000006", "Demo#2026", "user", True, False),
        ("Huda Ali", "huda@cybersense.app", "500000007", "Demo#2026", "admin", True, False),
        ("Karim Fadel", "karim@cybersense.app", "500000008", "Demo#2026", "user", True, True),
    ]
    for full_name, email, phone, password, role, active, banned in samples:
        if service._active_user(email=email):
            continue
        user = User(
            full_name=full_name,
            email=email,
            country_code="+971",
            phone_national=phone,
            phone_e164=f"+971{phone}",
            password_hash=hash_password(password),
            is_active=active and not banned,
            is_banned=banned,
            is_verified=True,
        )
        db.add(user)
        db.flush()
        service._set_role(user, role)
    db.commit()
