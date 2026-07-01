from waitress import serve
from app import create_app

print("Creating app...")

app = create_app()

print("App created.")

with app.app_context():
    from models.user import User

    print("\n=== DATABASE INFO ===")
    print(app.config["SQLALCHEMY_DATABASE_URI"])

    users = User.query.all()

    print(f"Total Users: {len(users)}")

    for user in users:
        print(f"ID={user.id}, Username={user.username}")

    print("=====================\n")

try:
    print("STARTING WAITRESS ON PORT 5000...")
    
    serve(
        app,
        host="0.0.0.0",
        port=5000,
        threads=20
    )

except Exception as e:
    print("WAITRESS ERROR:", e)

    import traceback
    traceback.print_exc()