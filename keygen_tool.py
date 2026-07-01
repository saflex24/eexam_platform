#!/usr/bin/env python3
"""
keygen_tool.py
==============
ABN Al-IHSAN DIGITAL SERVICES — License Key Generator
======================================================

Run this on Saheed's private machine ONLY.
The private key embedded here must NEVER be shared or committed to git.

Usage
-----
    python keygen_tool.py

The tool will interactively ask for:
  - School name
  - Machine ID (copied from /license page on customer's machine)
  - License duration (default: 1 year)

It then prints a license key that the customer pastes into /license/activate.

Requirements
------------
    pip install cryptography
"""

import base64
import json
import datetime
import sys

try:
    from cryptography.hazmat.primitives.asymmetric import padding
    from cryptography.hazmat.primitives import hashes, serialization
except ImportError:
    print("ERROR: cryptography library not installed.")
    print("Run:  pip install cryptography")
    sys.exit(1)


# ─────────────────────────────────────────────────────────────────────────────
# ⚠️  KEEP THIS PRIVATE KEY SECRET — NEVER SHARE OR COMMIT TO GIT ⚠️
# ─────────────────────────────────────────────────────────────────────────────
_PRIVATE_KEY_PEM = b"""-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAtxfShp5HLvvIXq13PiUnhCeJsS7p76ilH8YXvCqdbcHc6CVk
xEiXUHIzc7zs9ZGHRNEPSq43qZb3CQPg1SGCqxBzycc93Myn++9uQ4rg2bOTpKkW
I0hOKwS5XXVEXkKrpVONP/ux7cOoQca6j7z51NRPJxsT6e31t79NnWe2QvDfjqF0
8/yjT+E/Z3jLBzyEXRzwEIs0gQvmQ8JnX4z6H/KgxfPDlCO6LBx6tbJMFEKnt34r
mvAx11bM6G6NmDnRdBnv4sAI+hvD8a072G8dySLO+ovKIe5b6x0tWlUSrlgmRuLY
/P5rqn58A6TNWcHqin1bW9FClccrEA/BG7WMkQIDAQABAoIBAATWc6z0J2oXw8Fx
qKgLFAZXQ5l7hXmcPYGvip7Biv+Uit1U6JrRlrLs04x0MlgiOF5ifjqRTB32Y9BY
ioMjI6hYstCC69Dm1OzwlHujIqIJ70WfZJr5zPvwv+OW5r+tWAryIFYvlLHVNL/J
LBKCciD0G6PLQL1SeOa6HqdBL2UJHBJ1lac7qwKDhc3SdMDqB9qUZIaQiNLTyISQ
oX2Tik/7l+65s2dCL2XzQ3V5MUJQqKiViZ033rtqNOZEqgYUxyYs/iGU5MAZKeVw
ERRhtp297AGL72rUERQua4/sqh32lQDTdgBBQU5W5gPzu/946eDmW9JYxXvxsxRJ
UspMUqkCgYEA4BcTQZDrMDAosN0ZrRkcU0D2+dsYSykp4b1TjUDbixSu3cdyG5xw
IwhGaT1BUydaeCKuZL4IJwLIdat1huImVmCiHNbKfYPZKK0tA8szmWU/QQvIW0q+
YrzRI38gqehJ4rt74rrmDkW5O0uoUf5LqYSAmfx/IbtHQndO+HNKXOkCgYEA0So/
/wrV1cdmwWH95vjbf/vT5WYF8/Pfhv8CiLRWa0CS/zWhXegg5Ldo+itgePhzUuWr
I5ynl59TLXWMYKcjBnBOzzXeGa7uiv2LSScwsDZZYbJhWQhPFqgF9thYA3xY9sZW
5EOSmXBYdynlPeGsypPIy2UcFOI75k6p5QGfSWkCgYAE5zxaoOskgMlDJXNcYEJI
aBF/YhXj/yCVeekMHDExl+BDpguPIxspCRNRVi/JvAC0xD2Aos/W2q68NGY771Lb
bP3fF6wSlwH3a+KiRJ36a0a5C6L0rGwCCROibTOvxA9p0KRjT6edBFWLQJqMQL4z
FV0jAW1etZRXlfi6YvtrkQKBgH8h6QgB8/seWgyMnSD4faIK1L6IBnJC9sg807N3
uVczRqWsWUqUvvmFqV71Yovkp2PpiN36Z7s28f2dhxdwP0+4j45OtZJyyzbb6P8r
vOI+BpHlNFpDPJ8OvaFN2iE0QXatEz9m+wIcUQkNA/Na6gWvUcqeyDTBVZskkQtK
syCRAoGAIKeuHErtQIRf5vgTAaYpL4RZXBWBG1YLIl4MJiAtuRQ78MKH/4KEmz/7
KO1vwe/dDY9vJy0WFl21wKyTjLJNeDY9Y3Hf4H5RcUgt0R/Cdj4ggpy4SBcOptxe
9UyVf/tL4BCQtLMwXv5hkb+B9htxqIs/5Gw8jwqjF5ePxK12x5I=
-----END RSA PRIVATE KEY-----"""
# ─────────────────────────────────────────────────────────────────────────────


def generate_license(
    school_name: str,
    machine_id: str,
    months: int = 12,
    issued_date: datetime.date | None = None,
) -> str:
    """
    Sign and encode a license.

    Parameters
    ----------
    school_name : str   — display name of the school
    machine_id  : str   — 32-char hex fingerprint from the customer's /license page
    months      : int   — validity in months (default 12 = 1 year)
    issued_date : date  — override issue date (default today)

    Returns
    -------
    str — base64-encoded license key ready to paste
    """
    private_key = serialization.load_pem_private_key(_PRIVATE_KEY_PEM, password=None)

    today   = issued_date or datetime.date.today()
    expiry  = today + datetime.timedelta(days=30 * months)

    payload = {
        "school_name":  school_name.strip(),
        "machine_id":   machine_id.strip(),
        "issued_date":  today.strftime("%Y-%m-%d"),
        "expiry_date":  expiry.strftime("%Y-%m-%d"),
        "license_type": "yearly",
        "version":      1,
    }

    payload_bytes = json.dumps(payload, sort_keys=True).encode("utf-8")
    signature     = private_key.sign(payload_bytes, padding.PKCS1v15(), hashes.SHA256())
    sig_b64       = base64.b64encode(signature).decode("utf-8")

    license_data  = {"payload": payload, "signature": sig_b64}
    license_str   = base64.b64encode(
        json.dumps(license_data).encode("utf-8")
    ).decode("utf-8")

    return license_str


def _hr(char="─", width=60):
    print(char * width)


def main():
    _hr("═")
    print("  ABN Al-IHSAN DIGITAL SERVICES")
    print("  E-Exam Platform — License Key Generator")
    _hr("═")
    print()

    school_name = input("School name          : ").strip()
    if not school_name:
        print("ERROR: School name cannot be empty.")
        sys.exit(1)

    machine_id = input("Machine ID (from /license page): ").strip()
    if len(machine_id) != 32 or not all(c in "0123456789abcdef" for c in machine_id.lower()):
        print(f"WARNING: Machine ID looks unusual (expected 32 hex chars, got '{machine_id}').")
        cont = input("Continue anyway? [y/N]: ").strip().lower()
        if cont != "y":
            sys.exit(1)

    months_input = input("Duration in months   [12]: ").strip()
    months = 12
    if months_input:
        try:
            months = int(months_input)
            if months < 1 or months > 120:
                raise ValueError
        except ValueError:
            print("Invalid duration. Using 12 months.")
            months = 12

    print()
    _hr()

    license_key = generate_license(school_name, machine_id, months)

    expiry = (datetime.date.today() + datetime.timedelta(days=30 * months)).strftime("%Y-%m-%d")

    print(f"  School      : {school_name}")
    print(f"  Machine ID  : {machine_id}")
    print(f"  Issued      : {datetime.date.today().strftime('%Y-%m-%d')}")
    print(f"  Expires     : {expiry}  ({months} months)")
    print()
    _hr()
    print("  LICENSE KEY  (send this to the customer):")
    _hr()
    print()
    print(license_key)
    print()
    _hr()
    print("  Customer pastes this key into the /license page of their installation.")
    _hr()

    # Optionally save to file
    save = input("\nSave to file? [y/N]: ").strip().lower()
    if save == "y":
        safe_name = school_name.replace(" ", "_").lower()
        filename  = f"license_{safe_name}_{expiry}.txt"
        with open(filename, "w", encoding="utf-8") as f:
            f.write(f"School     : {school_name}\n")
            f.write(f"Machine ID : {machine_id}\n")
            f.write(f"Issued     : {datetime.date.today().strftime('%Y-%m-%d')}\n")
            f.write(f"Expires    : {expiry}\n\n")
            f.write("LICENSE KEY:\n")
            f.write(license_key + "\n")
        print(f"Saved → {filename}")


if __name__ == "__main__":
    main()
