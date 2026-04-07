"""
E-Exam Portal - PyInstaller Build Script
=========================================
Builds standalone Windows executable for E-Exam Portal
"""

import PyInstaller.__main__
import os
import shutil
import sys
from datetime import datetime


# Console Colors
class Colors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'


def print_header(text):
    print(f"\n{Colors.HEADER}{Colors.BOLD}{'=' * 60}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{text:^60}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{'=' * 60}{Colors.ENDC}\n")


def print_step(step, text):
    print(f"{Colors.OKBLUE}[{step}]{Colors.ENDC} {text}")


def print_success(text):
    print(f"{Colors.OKGREEN}  ✓ {text}{Colors.ENDC}")


def print_error(text):
    print(f"{Colors.FAIL}  ✗ {text}{Colors.ENDC}")


def print_warning(text):
    print(f"{Colors.WARNING}  ⚠ {text}{Colors.ENDC}")


def main():
    print_header("E-EXAM PORTAL - WINDOWS BUILD SCRIPT")

    # Step 1: Clean
    print_step("1/6", "Cleaning previous builds...")

    for folder in ['build', 'dist', '__pycache__']:
        if os.path.exists(folder):
            print(f"      Removing {folder}/")
            shutil.rmtree(folder)

    if os.path.exists('EExam.spec'):
        os.remove('EExam.spec')

    print_success("Clean complete")

    # Step 2: Verify files
    print_step("2/6", "Verifying project files...")

    required_files = ['app.py', 'templates', 'static']
    missing = []

    for file in required_files:
        if os.path.exists(file):
            print_success(f"Found {file}")
        else:
            print_error(f"Missing {file}")
            missing.append(file)

    if missing:
        print_error(f"Build aborted: Missing required files: {', '.join(missing)}")
        sys.exit(1)

    # Icon check
    icon_path = None
    possible_icons = [
        'static/favicon.ico',
        'static/img/favicon.ico',
        'static/images/favicon.ico',
        'favicon.ico'
    ]

    for icon in possible_icons:
        if os.path.exists(icon):
            icon_path = icon
            print_success(f"Found icon: {icon}")
            break

    if not icon_path:
        print_warning("No icon file found - default icon will be used")

    # Step 3: Configure build
    print_step("3/6", "Configuring build parameters...")

    build_params = [
        'app.py',
        '--name=EExam',
        '--onefile',
        '--console',
        '--add-data=templates;templates',
        '--add-data=static;static',
    ]

    if icon_path:
        build_params.append(f'--icon={icon_path}')

    if os.path.exists('migrations'):
        build_params.append('--add-data=migrations;migrations')
        print_success("Added migrations folder")

    # Hidden imports (INCLUDING PANDAS + NUMPY)
    hidden_imports = [
        'flask',
        'flask.cli',
        'flask_sqlalchemy',
        'flask_login',
        'flask_migrate',
        'werkzeug',
        'werkzeug.security',
        'jinja2',
        'jinja2.ext',
        'sqlalchemy',
        'sqlalchemy.sql.default_comparator',
        'sqlalchemy.orm',
        'psycopg2',
        'openpyxl',
        'openpyxl.cell._writer',
        'openpyxl.styles',
        'PIL',
        'PIL._imaging',
        'waitress',
        'email.mime.multipart',
        'email.mime.text',
        'datetime',
        'json',
        'secrets',
        'hashlib',
        'dotenv',

        # 🔥 CRITICAL FIX
        'pandas',
        'pandas._libs',
        'pandas._libs.tslibs',
        'pandas.io',
        'numpy',
    ]

    for imp in hidden_imports:
        build_params.append(f'--hidden-import={imp}')

    # Collect packages fully (important for pandas binaries)
    build_params.extend([
        '--collect-all=flask',
        '--collect-all=jinja2',
        '--collect-all=werkzeug',
        '--collect-all=sqlalchemy',
        '--collect-all=pandas',
        '--collect-all=numpy',
    ])

    # Exclude unnecessary modules (DO NOT exclude pandas or numpy)
    excludes = [
        'matplotlib',
        'scipy',
        'pytest',
        'IPython',
        'notebook',
        'tkinter',
    ]

    for exc in excludes:
        build_params.append(f'--exclude-module={exc}')

    print_success("Configuration complete")

    # Step 4: Build
    print_step("4/6", "Building executable...")
    print_warning("This may take several minutes...")

    try:
        PyInstaller.__main__.run(build_params)
        print_success("Build successful!")
    except Exception as e:
        print_error(f"Build failed: {e}")
        sys.exit(1)

    # Step 5: Distribution prep
    print_step("5/6", "Preparing distribution package...")

    dist_folder = 'dist'

    if os.path.exists('eexam.db'):
        shutil.copy('eexam.db', os.path.join(dist_folder, 'eexam.db'))
        print_success("Copied database")

    if os.path.exists('.env'):
        shutil.copy('.env', os.path.join(dist_folder, '.env'))
        print_success("Copied .env file")

    os.makedirs(os.path.join(dist_folder, 'uploads'), exist_ok=True)
    os.makedirs(os.path.join(dist_folder, 'logs'), exist_ok=True)

    print_success("Created uploads & logs folders")

    # README
    readme_content = f"E-Exam Portal Build\nBuild Date: {datetime.now()}\n"

    with open(os.path.join(dist_folder, 'README.txt'), 'w', encoding='utf-8') as f:
        f.write(readme_content)

    print_success("Created README.txt")

    # Batch file (UTF-8 safe)
    batch_content = """@echo off
chcp 65001 > nul
title E-Exam Portal Server
color 0A
cls
echo ===============================================
echo            E-EXAM PORTAL v2.0
echo ===============================================
echo.
echo Starting server...
echo http://localhost:5000
echo.
EExam.exe
pause
"""

    with open(os.path.join(dist_folder, 'Start-EExam.bat'), 'w', encoding='utf-8') as f:
        f.write(batch_content)

    print_success("Created Start-EExam.bat")

    # Step 6: Summary
    print_step("6/6", "Build Summary")

    exe_path = os.path.join(dist_folder, 'EExam.exe')
    exe_size = os.path.getsize(exe_path) / (1024 * 1024)

    print(f"\nExecutable: {exe_path}")
    print(f"Size: {exe_size:.1f} MB")
    print("\nBuild completed successfully.\n")


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("Build cancelled.")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)
