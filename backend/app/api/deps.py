from typing import Optional
from uuid import UUID

from fastapi import Depends, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.errors import AppError
from app.core.security import decode_token
from app.models import User, UserSession
from app.services.accounts import has_permission, now

bearer = HTTPBearer(auto_error=False)


class Current:
    def __init__(self, user: User, session_id: UUID) -> None:
        self.user = user
        self.session_id = session_id


def get_current(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(bearer),
    db: Session = Depends(get_db),
) -> Current:
    if credentials is None:
        raise AppError("UNAUTHORIZED", "Session is not valid", 401)
    payload = decode_token(credentials.credentials)
    if payload.get("type") != "access":
        raise AppError("UNAUTHORIZED", "Session is not valid", 401)
    session = db.get(UserSession, UUID(payload["sid"]))
    if session is None or session.revoked_at is not None or session.expires_at < now():
        raise AppError("UNAUTHORIZED", "Session is not valid", 401)
    user = db.get(User, UUID(payload["sub"]))
    if user is None or user.deleted_at is not None or user.is_banned or not user.is_active:
        raise AppError("UNAUTHORIZED", "Session is not valid", 401)
    session.last_used_at = now()
    db.commit()
    return Current(user=user, session_id=session.id)


def require(permission: str):
    def _inner(current: Current = Depends(get_current)) -> Current:
        if not has_permission(current.user, permission):
            raise AppError("FORBIDDEN", "You do not have access to this action", 403)
        return current

    return _inner


def client_ip(request: Request) -> str:
    if request.client is None:
        return ""
    return request.client.host or ""


def device_from(request: Request, fallback: str) -> str:
    return (request.headers.get("x-device-name") or fallback or "Unknown device")[:160]
