import httpx

from app.core.config import settings
from app.core.errors import AppError


class OtpSender:
    def send(self, phone_e164: str, code: str) -> None:
        raise NotImplementedError


class MockOtpSender(OtpSender):
    def send(self, phone_e164: str, code: str) -> None:
        return


class WhatsAppCloudSender(OtpSender):
    def send(self, phone_e164: str, code: str) -> None:
        if not settings.whatsapp_token or not settings.whatsapp_phone_number_id:
            raise AppError("OTP_SEND_FAILED", "WhatsApp is not configured", 502)
        components: list[dict] = [{"type": "body", "parameters": [{"type": "text", "text": code}]}]
        if settings.whatsapp_template_has_button:
            components.append(
                {
                    "type": "button",
                    "sub_type": "url",
                    "index": "0",
                    "parameters": [{"type": "text", "text": code}],
                }
            )
        payload = {
            "messaging_product": "whatsapp",
            "to": phone_e164.lstrip("+"),
            "type": "template",
            "template": {
                "name": settings.whatsapp_template_name,
                "language": {"code": settings.whatsapp_template_lang},
                "components": components,
            },
        }
        url = f"https://graph.facebook.com/{settings.whatsapp_api_version}/{settings.whatsapp_phone_number_id}/messages"
        try:
            response = httpx.post(
                url,
                json=payload,
                headers={"Authorization": f"Bearer {settings.whatsapp_token}"},
                timeout=15,
            )
        except httpx.HTTPError as exc:
            raise AppError("OTP_SEND_FAILED", "WhatsApp could not be reached", 502) from exc
        if response.status_code >= 300:
            raise AppError("OTP_SEND_FAILED", "WhatsApp rejected the message", 502)


def build_sender() -> OtpSender:
    if settings.otp_provider == "whatsapp":
        return WhatsAppCloudSender()
    return MockOtpSender()
