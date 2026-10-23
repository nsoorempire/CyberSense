from fastapi import FastAPI, Request
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.api.v1.routes import router
from app.core.config import settings
from app.core.database import SessionLocal, engine
from app.core.errors import AppError
from app.models import entities as _entities  # noqa: F401
from app.core.database import Base
from app.services.accounts import seed

settings.assert_safe()

app = FastAPI(title="Cyber Sense", version="1.0.0", description="Accounts, sessions, and role-based access for Cyber Sense.")
origins = ["*"] if settings.cors_origins.strip() == "*" else [item.strip() for item in settings.cors_origins.split(",") if item.strip()]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=origins != ["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(router, prefix="/api/v1")


@app.exception_handler(AppError)
def app_error(_: Request, exc: AppError) -> JSONResponse:
    return JSONResponse(status_code=exc.status_code, content={"detail": {"code": exc.code, "message": exc.message, **exc.extra}})


@app.exception_handler(RequestValidationError)
def validation_error(_: Request, exc: RequestValidationError) -> JSONResponse:
    return JSONResponse(status_code=422, content={"detail": {"code": "VALIDATION", "message": "Check the submitted fields"}})


@app.on_event("startup")
def startup() -> None:
    if settings.auto_create_tables:
        Base.metadata.create_all(bind=engine)
    if settings.seed_on_startup:
        db = SessionLocal()
        try:
            seed(db)
        finally:
            db.close()
