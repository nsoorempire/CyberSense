import hashlib
import hmac
import re
import secrets
from datetime import datetime, timedelta, timezone
from uuid import UUID

import jwt
from argon2 import PasswordHasher
from argon2.exceptions import InvalidHash, VerificationError, VerifyMismatchError

from app.core.config import settings
from app.core.errors import AppError

_hasher = PasswordHasher()
_PASSWORD = re.compile(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,128}$")


def validate_password(password: str) -> None:
    if not _PASSWORD.match(password):
        raise AppError("VALIDATION", "Password must be 8-128 characters and include upper, lower, number, and symbol", 422)


def hash_password(password: str) -> str:
    return _hasher.hash(password)


def verify_password(password: str, hashed: str) -> bool:
    try:
        return _hasher.verify(hashed, password)
    except (VerifyMismatchError, VerificationError, InvalidHash):
        return False


def hash_otp(code: str) -> str:
    return hmac.new(settings.otp_pepper.encode(), code.encode(), hashlib.sha256).hexdigest()


def otp_matches(code: str, hashed: str) -> bool:
    return hmac.compare_digest(hash_otp(code), hashed)


def generate_otp() -> str:
    return f"{secrets.randbelow(1_000_000):06d}"


def new_token() -> str:
    return secrets.token_urlsafe(48)


def hash_token(token: str) -> str:
    return hashlib.sha256(token.encode()).hexdigest()


def encode_token(payload: dict) -> str:
    return jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_algorithm)


def decode_token(token: str) -> dict:
    try:
        return jwt.decode(token, settings.jwt_secret, algorithms=[settings.jwt_algorithm])
    except jwt.PyJWTError as exc:
        raise AppError("UNAUTHORIZED", "Session is not valid", 401) from exc


def access_token(user_id: UUID, session_id: UUID, role: str) -> str:
    now = datetime.now(timezone.utc)
    return encode_token(
        {
            "sub": str(user_id),
            "sid": str(session_id),
            "role": role,
            "type": "access",
            "iat": int(now.timestamp()),
            "exp": now + timedelta(minutes=settings.access_token_minutes),
        }
    )


def mask_phone(phone: str) -> str:
    if len(phone) <= 6:
        return phone
    return f"{phone[:4]}••••{phone[-3:]}"


def normalize_phone(country_code: str, national: str) -> tuple[str, str, str]:
    dial_digits = re.sub(r"\D", "", country_code)
    number = re.sub(r"\D", "", national)
    if not dial_digits or not (7 <= len(number) <= 12):
        raise AppError("VALIDATION", "Enter a valid phone number", 422)
    e164 = f"+{dial_digits}{number}"
    if not re.fullmatch(r"\+[1-9]\d{7,14}", e164):
        raise AppError("VALIDATION", "Enter a valid phone number", 422)
    return f"+{dial_digits}", number, e164
