import time
import psycopg2
import os

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")

if not DB_NAME or not DB_USER or not DB_PASS:
    print("❌ Missing DB credentials. Set DB_NAME, DB_USER, DB_PASS environment variables.")
    exit(1)

for i in range(10):
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        conn.close()
        print("✅ DB READY")
        break
    except Exception:
        print("⏳ Waiting for DB...")
        time.sleep(2)
else:
    print("❌ DB NOT READY")
    exit(1)

try:
    import subprocess
    result = subprocess.run(
        ["python", "-m", "flask", "db", "upgrade"],
        env={**os.environ, "FLASK_APP": "wsgi.py"},
        capture_output=True,
        text=True
    )
    print(result.stdout)
    if result.returncode != 0:
        print(f"❌ Migration failed: {result.stderr}")
        exit(1)
    print("✅ MIGRATIONS APPLIED")
except Exception as e:
    print(f"❌ Migration failed: {e}")
    exit(1)
