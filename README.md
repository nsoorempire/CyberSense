# Cyber Sense

## التشغيل

```bash
flutter pub get
flutter run
```

التطبيق يفتح في وضع المعاينة. الحسابات تبقى على الجهاز، ورمز التحقق يظهر على شاشة OTP.

| الدور | البريد | كلمة المرور | واتساب |
| --- | --- | --- | --- |
| مسؤول | admin@cybersense.app | Admin#2026 | +971500000001 |
| مستخدم | user@cybersense.app | User#2026 | +971500000002 |

اللغة والمظهر يُحفظان من الإعدادات، والعربية تقلب الواجهة من اليمين إلى اليسار.

لتشغيل الواجهة الخلفية:

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
docker compose up -d
cp .env.example .env
uvicorn app.main:app --reload --app-dir .
```

ثم:

```bash
flutter run --dart-define=USE_MOCK=false --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1
```

على محاكي أندرويد استخدم `http://10.0.2.2:8000/api/v1`. التوثيق التفاعلي على `http://127.0.0.1:8000/docs`.

إرسال واتساب يعمل عبر مزود تجريبي أثناء التطوير. لتفعيل Meta WhatsApp Cloud API اضبط `OTP_PROVIDER=whatsapp` وبيانات القالب في `backend/.env`. لا تُحفظ كلمات المرور ولا رموز التحقق بنصها الأصلي.

## English

Cyber Sense is a cybersecurity application foundation: accounts, WhatsApp verification, sessions, and user/admin access. Threat analysis, email scanning, link checking, and security reports are reserved screens only. They are not implemented.

The interface is Flutter. The API is FastAPI. The database is PostgreSQL. Passwords are Argon2 hashes. Verification codes are stored as hashes.

## Mobile app

```bash
flutter pub get
flutter run
```

The app starts in preview mode. Accounts stay on the device, and the development OTP is shown on the verification screen.

| Role | Email | Password | WhatsApp |
| --- | --- | --- | --- |
| Admin | admin@cybersense.app | Admin#2026 | +971500000001 |
| User | user@cybersense.app | User#2026 | +971500000002 |

Language and appearance are saved from Settings. Arabic switches the layout to right-to-left.

To use the API instead of preview data:

```bash
flutter run --dart-define=USE_MOCK=false --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1
```

An Android emulator reaches the computer at `http://10.0.2.2:8000/api/v1`.

## API

Python 3.9 or newer.

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
docker compose up -d
cp .env.example .env
uvicorn app.main:app --reload --app-dir .
```

Open `http://127.0.0.1:8000/docs`.

On startup the API creates the tables and seeds the same demo accounts. Set `OTP_PROVIDER=whatsapp` only after the Meta Cloud API values in `.env` are filled. Until then the provider is `mock`, and `EXPOSE_DEV_OTP=true` returns the code in the API response for local testing. Do not enable that outside development.

The versioned schema is in `backend/alembic`. For a migration-managed database set `AUTO_CREATE_TABLES=false`, then run `alembic upgrade head` from `backend`.

## Access

Signing in checks the password, sends a one-time code, then returns a short-lived access token and a rotating refresh token. Admins can search accounts, change roles, and activate, deactivate, ban, or delete them. A person cannot change their own access. Sessions can be ended one by one or all at once.
