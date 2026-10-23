from datetime import datetime
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, EmailStr, Field


class UserPublic(BaseModel):
    id: UUID
    full_name: str
    email: EmailStr
    country_code: str
    phone_national: str
    phone_e164: str
    role: str
    is_active: bool
    is_banned: bool
    is_verified: bool
    created_at: datetime
    last_login_at: Optional[datetime] = None


class ChallengeResponse(BaseModel):
    challenge_id: UUID
    masked_phone: str
    purpose: str
    expires_in: int
    resend_in: int
    attempts_left: int
    dev_code: Optional[str] = None


class TokenResponse(BaseModel):
    access_token: Optional[str] = None
    refresh_token: Optional[str] = None
    token_type: str = "bearer"
    expires_in: Optional[int] = None
    reset_token: Optional[str] = None
    user: Optional[UserPublic] = None


class RegisterRequest(BaseModel):
    full_name: str = Field(min_length=2, max_length=80)
    email: EmailStr
    country_code: str
    phone: str
    password: str = Field(min_length=8, max_length=128)
    device_name: str = "Unknown device"


class LoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=1, max_length=128)
    device_name: str = "Unknown device"


class VerifyOtpRequest(BaseModel):
    challenge_id: UUID
    code: str = Field(min_length=6, max_length=6)
    device_name: str = "Unknown device"


class ResendOtpRequest(BaseModel):
    challenge_id: UUID


class ForgotPasswordRequest(BaseModel):
    country_code: str
    phone: str
    device_name: str = "Unknown device"


class ResetPasswordRequest(BaseModel):
    reset_token: str
    new_password: str = Field(min_length=8, max_length=128)


class RefreshRequest(BaseModel):
    refresh_token: str


class ProfileUpdate(BaseModel):
    full_name: str = Field(min_length=2, max_length=80)
    country_code: str
    phone: str


class PasswordChange(BaseModel):
    current_password: str = Field(min_length=1, max_length=128)
    new_password: str = Field(min_length=8, max_length=128)


class UserUpdate(BaseModel):
    role: Optional[str] = None
    is_active: Optional[bool] = None
    is_banned: Optional[bool] = None
    deleted: bool = False


class UserStats(BaseModel):
    total: int
    active: int
    banned: int
    inactive: int


class UserList(BaseModel):
    items: list[UserPublic]
    total: int


class ActivityPublic(BaseModel):
    id: UUID
    user_name: Optional[str] = None
    email: str
    success: bool
    device_name: str
    ip_address: str
    failure_reason: Optional[str] = None
    created_at: datetime


class ActivityList(BaseModel):
    items: list[ActivityPublic]


class SessionPublic(BaseModel):
    id: UUID
    device_name: str
    ip_address: str
    created_at: datetime
    last_used_at: datetime
    current: bool


class SessionList(BaseModel):
    items: list[SessionPublic]
