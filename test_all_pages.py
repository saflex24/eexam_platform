import traceback

try:
    from app import create_app
    app = create_app()

    logins = {
        'admin':   {'username': 'admin',   'password': 'password123', 'pages': [
            '/admin/dashboard',
            '/admin/students',
            '/admin/teachers',
            '/admin/classes',
            '/admin/exams',
            '/admin/users',
            '/admin/analytics',
        ]},
        'student': {'username': 'ST009',   'password': 'password123', 'pages': [
            '/student/dashboard',
            '/student/results',
            '/student/class-ranking',
        ]},
        'teacher': {'username': 'teacher1','password': 'password123', 'pages': [
            '/teacher/dashboard',
            '/teacher/exams',
        ]},
    }

    with app.test_client() as client:
        for role, config in logins.items():
            print(f"\n{'='*50}")
            print(f"  Testing as {role}: {config['username']}")
            print(f"{'='*50}")

            # Logout first
            client.get('/logout', follow_redirects=True)

            # Login
            resp = client.post('/login', data={
                'username': config['username'],
                'password': config['password']
            }, follow_redirects=True)

            if resp.status_code != 200:
                print(f"  ✗ Login failed with code {resp.status_code}")
                continue
            else:
                print(f"  ✓ Logged in successfully\n")

            # Test each page
            for page in config['pages']:
                resp = client.get(page, follow_redirects=True)
                status = "✓" if resp.status_code == 200 else "✗"
                print(f"  {status} {resp.status_code}  {page}")

                # If 500, show first 500 chars of error
                if resp.status_code == 500:
                    error_text = resp.data.decode('utf-8')
                    # Try to find the actual error message
                    if 'Exception' in error_text or 'Error' in error_text:
                        lines = error_text.split('\n')
                        for line in lines:
                            if 'Error' in line or 'Exception' in line or 'error' in line:
                                print(f"       → {line.strip()}")

    print(f"\n{'='*50}")
    print("  All page tests complete!")
    print(f"{'='*50}\n")

except Exception as e:
    print(f"ERROR: {e}")
    traceback.print_exc()