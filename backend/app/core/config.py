from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    app_name: str = "Cyber Sense"
    database_url: str = "postgresql+psycopg://cybersense:cybersense@localhost:5432/cybersense"
    jwt_secret: str = "dev-only-change-me"
    jwt_algorithm: str = "HS256"
    access_token_minutes: int = 15
    refresh_token_days: int = 30
    otp_pepper: str = "dev-only-otp-pepper"
    otp_ttl_seconds: int = 300
    otp_resend_seconds: int = 60
    otp_max_attempts: int = 5
    otp_provider: str = "mock"
    debug: bool = True
    expose_dev_otp: bool = True
    seed_on_startup: bool = True
    auto_create_tables: bool = True
    cors_origins: str = "*"
    whatsapp_token: str = ""
    whatsapp_phone_number_id: str = ""
    whatsapp_template_name: str = "otp_authentication"
    whatsapp_template_lang: str = "en"
    whatsapp_api_version: str = "v21.0"
    whatsapp_template_has_button: bool = True

    def assert_safe(self) -> None:
        if self.debug:
            return
        if self.jwt_secret.startswith("dev-only") or self.otp_pepper.startswith("dev-only"):
            raise RuntimeError("Set JWT_SECRET and OTP_PEPPER before running with DEBUG=false")
        if self.expose_dev_otp:
            raise RuntimeError("Set EXPOSE_DEV_OTP=false when DEBUG=false")


settings = Settings()
