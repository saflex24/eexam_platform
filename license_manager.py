"""
license_manager.py
==================
Offline, yearly, per-installation license system for Al-Ihan E-Exam Platform.

HOW IT WORKS
------------
1. On first run (or after license expires) the app shows a locked page.
2. The admin visits /license → copies their Machine ID.
3. Admin sends the Machine ID to Saheed (ABN Al-IHSAN DIGITAL SERVICES).
4. Saheed runs keygen_tool.py on his private machine → produces a license key.
5. Admin pastes the license key into /license/activate.
6. App verifies the RSA signature and machine fingerprint offline,
   then writes license.lic next to the executable.
7. On every app startup, check_license() is called from app.py.
   If expired / invalid / wrong machine → all routes redirect to /license.

SECURITY
--------
* RSA-2048 signature (SHA-256) — cannot be forged without the private key.
* Machine fingerprint (hostname + OS + hardware info) → hash.
  Even if someone copies the .lic file to another machine it won't work.
* License file is stored in plaintext JSON (base64-encoded) so it is human-
  readable but NOT editable without invalidating the signature.
* Private key NEVER leaves Saheed's machine.
"""

import os
import sys
import json
import base64
import hashlib
import platform
import datetime
import logging

from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import hashes, serialization

logger = logging.getLogger(__name__)

# ─────────────────────────────────────────────────────────────────
# PUBLIC KEY — embedded in the application.
# Generated once by Saheed. The matching private key is kept secret.
# ─────────────────────────────────────────────────────────────────
_PUBLIC_KEY_PEM = b"""-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtxfShp5HLvvIXq13PiUn
hCeJsS7p76ilH8YXvCqdbcHc6CVkxEiXUHIzc7zs9ZGHRNEPSq43qZb3CQPg1SGC
qxBzycc93Myn++9uQ4rg2bOTpKkWI0hOKwS5XXVEXkKrpVONP/ux7cOoQca6j7z5
1NRPJxsT6e31t79NnWe2QvDfjqF08/yjT+E/Z3jLBzyEXRzwEIs0gQvmQ8JnX4z6
H/KgxfPDlCO6LBx6tbJMFEKnt34rmvAx11bM6G6NmDnRdBnv4sAI+hvD8a072G8d
ySLO+ovKIe5b6x0tWlUSrlgmRuLY/P5rqn58A6TNWcHqin1bW9FClccrEA/BG7WM
kQIDAQAB
-----END PUBLIC KEY-----"""

LICENSE_FILENAME = "license.lic"


# ─────────────────────────────────────────────────────────────────
# HELPERS
# ─────────────────────────────────────────────────────────────────

def _app_dir() -> str:
    """Return the directory that contains the running app / executable."""
    if getattr(sys, "frozen", False):
        return os.path.dirname(sys.executable)
    return os.path.dirname(os.path.abspath(__file__))


def _license_path() -> str:
    return os.path.join(_app_dir(), LICENSE_FILENAME)


def get_machine_id() -> str:
    """
    Produce a stable fingerprint for this installation.
    Uses: hostname, OS platform, processor, machine architecture.
    Falls back gracefully if any value is unavailable.
    """
    parts = [
        platform.node(),          # hostname
        platform.system(),        # Windows / Linux / Darwin
        platform.machine(),       # x86_64 / AMD64 / arm64
        platform.processor(),     # processor string
    ]
    raw = "|".join(str(p).strip() for p in parts)
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()[:32]


def _load_public_key():
    return serialization.load_pem_public_key(_PUBLIC_KEY_PEM)


# ─────────────────────────────────────────────────────────────────
# CORE: VERIFY A LICENSE STRING
# ─────────────────────────────────────────────────────────────────

class LicenseError(Exception):
    """Raised when a license is invalid, expired, or machine-mismatched."""
    pass


def verify_license_string(license_str: str) -> dict:
    """
    Verify a base64-encoded license string.

    Returns the payload dict on success.
    Raises LicenseError with a human-readable message on failure.
    """
    try:
        raw_json = base64.b64decode(license_str.strip().encode()).decode("utf-8")
        license_data = json.loads(raw_json)
    except Exception:
        raise LicenseError("License key is corrupted or not a valid format.")

    if "payload" not in license_data or "signature" not in license_data:
        raise LicenseError("License key is missing required fields.")

    payload   = license_data["payload"]
    signature = base64.b64decode(license_data["signature"])
    payload_bytes = json.dumps(payload, sort_keys=True).encode("utf-8")

    # 1. Verify RSA signature
    try:
        pub_key = _load_public_key()
        pub_key.verify(signature, payload_bytes, padding.PKCS1v15(), hashes.SHA256())
    except Exception:
        raise LicenseError("License signature is invalid. This key may have been tampered with.")

    # 2. Check machine fingerprint
    expected_machine = payload.get("machine_id", "")
    actual_machine   = get_machine_id()
    if expected_machine != actual_machine:
        raise LicenseError(
            f"This license is not valid for this machine.\n"
            f"Expected machine ID: {expected_machine}\n"
            f"This machine ID:     {actual_machine}"
        )

    # 3. Check expiry
    try:
        expiry_date = datetime.datetime.strptime(payload["expiry_date"], "%Y-%m-%d")
    except Exception:
        raise LicenseError("License has an unreadable expiry date.")

    if datetime.datetime.now() > expiry_date:
        raise LicenseError(
            f"License expired on {payload['expiry_date']}. "
            "Please contact ABN Al-IHSAN DIGITAL SERVICES for renewal."
        )

    return payload


# ─────────────────────────────────────────────────────────────────
# SAVE / LOAD LICENSE FILE
# ─────────────────────────────────────────────────────────────────

def save_license(license_str: str) -> dict:
    """Verify then persist license to disk. Returns payload on success."""
    payload = verify_license_string(license_str)   # raises on failure
    with open(_license_path(), "w", encoding="utf-8") as f:
        f.write(license_str.strip())
    logger.info(f"License saved. School: {payload.get('school_name')}  Expires: {payload.get('expiry_date')}")
    return payload


def load_license_from_disk() -> str | None:
    """Read the .lic file from disk. Returns raw string or None."""
    path = _license_path()
    if not os.path.exists(path):
        return None
    try:
        with open(path, "r", encoding="utf-8") as f:
            return f.read().strip()
    except Exception as e:
        logger.warning(f"Could not read license file: {e}")
        return None


# ─────────────────────────────────────────────────────────────────
# MAIN CHECK — called from app.py on startup & per-request
# ─────────────────────────────────────────────────────────────────

_license_cache: dict | None = None   # in-process cache so disk is read once


def check_license() -> tuple[bool, str, dict | None]:
    """
    Returns (is_valid: bool, message: str, payload: dict|None).

    This is the ONLY function you need to call from outside this module.
    """
    global _license_cache

    if _license_cache is not None:
        # Re-verify expiry from cache (no disk I/O needed)
        try:
            expiry = datetime.datetime.strptime(_license_cache["expiry_date"], "%Y-%m-%d")
            if datetime.datetime.now() > expiry:
                _license_cache = None
                return False, "License has expired.", None
            return True, "License valid.", _license_cache
        except Exception:
            _license_cache = None

    raw = load_license_from_disk()
    if raw is None:
        return False, "No license file found.", None

    try:
        payload = verify_license_string(raw)
        _license_cache = payload
        return True, "License valid.", payload
    except LicenseError as e:
        return False, str(e), None


def invalidate_cache():
    """Call after saving a new license so it is re-read immediately."""
    global _license_cache
    _license_cache = None
