"""
routes/license.py
=================
License portal routes for the E-Exam platform.

Routes
------
GET  /license                → show license status + Machine ID
POST /license/activate       → accept a pasted license key, verify & save
GET  /license/status  (JSON) → used by admin dashboard widget
"""

from flask import (
    Blueprint, render_template, request, redirect,
    url_for, flash, jsonify, session
)
from flask_login import login_required, current_user

from license_manager import (
    get_machine_id,
    check_license,
    save_license,
    invalidate_cache,
    LicenseError,
)

license_bp = Blueprint("license", __name__, url_prefix="/license")


# ─── Helpers ──────────────────────────────────────────────────────────────────

def _is_admin():
    return (
        current_user.is_authenticated
        and hasattr(current_user, "role")
        and current_user.role.name == "Admin"
    )


# ─── Routes ───────────────────────────────────────────────────────────────────

@license_bp.route("/", methods=["GET"])
def license_page():
    """
    Public license page — shown to EVERYONE when license is invalid.
    Also accessible by admin at any time.
    """
    valid, message, payload = check_license()

    machine_id = get_machine_id()

    return render_template(
        "license/license.html",
        machine_id=machine_id,
        license_valid=valid,
        license_message=message,
        license_payload=payload,
    )


@license_bp.route("/activate", methods=["POST"])
def activate():
    """Accept a pasted license key, verify and save it."""
    license_key = request.form.get("license_key", "").strip()

    if not license_key:
        flash("Please paste a license key.", "warning")
        return redirect(url_for("license.license_page"))

    try:
        payload = save_license(license_key)
        invalidate_cache()
        flash(
            f"✅ License activated successfully! "
            f"School: {payload.get('school_name', 'N/A')} | "
            f"Valid until: {payload.get('expiry_date', 'N/A')}",
            "success",
        )
        # Redirect admin to dashboard, others to login
        if _is_admin():
            return redirect(url_for("admin.dashboard"))
        return redirect(url_for("auth.login"))

    except LicenseError as e:
        flash(f"❌ Activation failed: {e}", "danger")
        return redirect(url_for("license.license_page"))

    except Exception as e:
        flash(f"Unexpected error: {e}", "danger")
        return redirect(url_for("license.license_page"))


@license_bp.route("/status", methods=["GET"])
@login_required
def license_status():
    """JSON endpoint — used by the admin dashboard widget."""
    if not _is_admin():
        return jsonify({"error": "Forbidden"}), 403

    valid, message, payload = check_license()
    machine_id = get_machine_id()

    days_left = None
    if payload and payload.get("expiry_date"):
        import datetime
        expiry = datetime.datetime.strptime(payload["expiry_date"], "%Y-%m-%d")
        days_left = (expiry - datetime.datetime.now()).days

    return jsonify(
        {
            "valid": valid,
            "message": message,
            "machine_id": machine_id,
            "school_name": payload.get("school_name") if payload else None,
            "expiry_date": payload.get("expiry_date") if payload else None,
            "days_left": days_left,
            "license_type": payload.get("license_type") if payload else None,
        }
    )
