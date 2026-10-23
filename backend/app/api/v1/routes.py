from uuid import UUID

from fastapi import APIRouter, Depends, Query, Request, Response
from sqlalchemy.orm import Session

from app.api.deps import Current, client_ip, device_from, get_current, require
from app.core.database import get_db
from app.schemas.common import (
    ActivityList,
    ChallengeResponse,
    ForgotPasswordRequest,
    LoginRequest,
    PasswordChange,
    ProfileUpdate,
    RefreshRequest,
    RegisterRequest,
    ResendOtpRequest,
    ResetPasswordRequest,
    SessionList,
    TokenResponse,
    UserList,
    UserPublic,
    UserStats,
    UserUpdate,
    VerifyOtpRequest,
)
from app.services.accounts import AccountService, to_public
from app.services.otp_provider import build_sender

router = APIRouter()


def service(db: Session = Depends(get_db)) -> AccountService:
    return AccountService(db, build_sender())


@router.get("/health")
def health() -> dict:
    return {"status": "ok", "service": "cyber-sense"}


@router.post("/auth/register", response_model=ChallengeResponse)
def register(body: RegisterRequest, db_service: AccountService = Depends(service)) -> ChallengeResponse:
    return db_service.register(body.full_name, str(body.email), body.country_code, body.phone, body.password)


@router.post("/auth/login", response_model=ChallengeResponse)
def login(body: LoginRequest, request: Request, db_service: AccountService = Depends(service)) -> ChallengeResponse:
    return db_service.login(str(body.email), body.password, device_from(request, body.device_name), client_ip(request), request.headers.get("user-agent", ""))


@router.post("/auth/verify-otp", response_model=TokenResponse)
def verify_otp(body: VerifyOtpRequest, request: Request, db_service: AccountService = Depends(service)) -> TokenResponse:
    return db_service.verify(body.challenge_id, body.code, device_from(request, body.device_name), client_ip(request), request.headers.get("user-agent", ""))


@router.post("/auth/resend-otp", response_model=ChallengeResponse)
def resend_otp(body: ResendOtpRequest, db_service: AccountService = Depends(service)) -> ChallengeResponse:
    return db_service.resend(body.challenge_id)


@router.post("/auth/forgot-password", response_model=ChallengeResponse)
def forgot_password(body: ForgotPasswordRequest, db_service: AccountService = Depends(service)) -> ChallengeResponse:
    return db_service.forgot_password(body.country_code, body.phone)


@router.post("/auth/reset-password", status_code=204)
def reset_password(body: ResetPasswordRequest, db_service: AccountService = Depends(service)) -> Response:
    db_service.reset_password(body.reset_token, body.new_password)
    return Response(status_code=204)


@router.post("/auth/refresh", response_model=TokenResponse)
def refresh(body: RefreshRequest, request: Request, db_service: AccountService = Depends(service)) -> TokenResponse:
    return db_service.refresh(body.refresh_token, device_from(request, ""), client_ip(request))


@router.delete("/auth/logout", status_code=204)
def logout(current: Current = Depends(get_current), db_service: AccountService = Depends(service)) -> Response:
    db_service.logout(current.session_id)
    return Response(status_code=204)


@router.get("/users/me", response_model=UserPublic)
def me(current: Current = Depends(get_current)) -> UserPublic:
    return to_public(current.user)


@router.patch("/users/me", response_model=UserPublic)
def update_me(body: ProfileUpdate, current: Current = Depends(require("profile.update")), db_service: AccountService = Depends(service)) -> UserPublic:
    return db_service.update_profile(current.user, body.full_name, body.country_code, body.phone)


@router.post("/users/me/password", status_code=204)
def change_password(body: PasswordChange, current: Current = Depends(require("profile.update")), db_service: AccountService = Depends(service)) -> Response:
    db_service.change_password(current.user, body.current_password, body.new_password)
    return Response(status_code=204)


@router.get("/users/stats", response_model=UserStats)
def stats(current: Current = Depends(require("users.read")), db_service: AccountService = Depends(service)) -> UserStats:
    return db_service.stats()


@router.get("/users", response_model=UserList)
def users(
    q: str = "",
    status: str = Query(default="all"),
    current: Current = Depends(require("users.read")),
    db_service: AccountService = Depends(service),
) -> UserList:
    items = db_service.list_users(q, status)
    return UserList(items=items, total=len(items))


@router.patch("/users/{user_id}", response_model=UserPublic)
def update_user(
    user_id: UUID,
    body: UserUpdate,
    current: Current = Depends(require("users.update")),
    db_service: AccountService = Depends(service),
) -> UserPublic:
    return db_service.update_user(current.user, user_id, body.role, body.is_active, body.is_banned, body.deleted)


@router.get("/activity", response_model=ActivityList)
def activity(current: Current = Depends(require("activity.read")), db_service: AccountService = Depends(service)) -> ActivityList:
    return ActivityList(items=db_service.activity_for(current.user))


@router.get("/sessions", response_model=SessionList)
def sessions(current: Current = Depends(get_current), db_service: AccountService = Depends(service)) -> SessionList:
    return SessionList(items=db_service.sessions_for(current.user, current.session_id))


@router.delete("/sessions/{session_id}", status_code=204)
def revoke_session(session_id: UUID, current: Current = Depends(require("sessions.manage")), db_service: AccountService = Depends(service)) -> Response:
    db_service.revoke_session(current.user, session_id)
    return Response(status_code=204)


@router.delete("/sessions", status_code=204)
def revoke_sessions(current: Current = Depends(require("sessions.manage")), db_service: AccountService = Depends(service)) -> Response:
    db_service.revoke_all(current.user.id)
    return Response(status_code=204)
