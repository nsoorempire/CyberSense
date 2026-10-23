from app.core.security import hash_otp, hash_password, normalize_phone, otp_matches, validate_password, verify_password
from app.core.errors import AppError
import pytest


def test_password_is_argon2_and_not_reversible():
    hashed = hash_password("User#2026")
    assert hashed.startswith("$argon2")
    assert "User#2026" not in hashed
    assert verify_password("User#2026", hashed)
    assert not verify_password("wrong-password", hashed)


def test_otp_is_stored_as_a_hash():
    digest = hash_otp("123456")
    assert digest != "123456"
    assert otp_matches("123456", digest)
    assert not otp_matches("000000", digest)


def test_password_rules_reject_weak_values():
    with pytest.raises(AppError):
        validate_password("password")


def test_phone_becomes_e164():
    dial, national, e164 = normalize_phone("+971", "50 000 0002")
    assert dial == "+971"
    assert national == "500000002"
    assert e164 == "+971500000002"
