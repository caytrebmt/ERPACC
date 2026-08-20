"""Wait for PostgreSQL and apply the Alembic migrations.

This script is used by the container and Railway entrypoints.  It deliberately
runs migrations only after PostgreSQL accepts connections.  Schema changes
belong to Alembic; applying an ``ALTER TABLE`` before migrations made a fresh
installation fail because ``online_orders`` did not exist yet.
"""

from __future__ import annotations

import os
import subprocess
import sys
import time

import psycopg2


RETRY_COUNT = int(os.getenv("DB_WAIT_RETRIES", "30"))
RETRY_DELAY = float(os.getenv("DB_WAIT_DELAY", "2"))
DATABASE_URL = (os.getenv("DATABASE_URL") or "").strip()


def _database_dsn() -> str | None:
    """Return a psycopg2-compatible DSN when DATABASE_URL is configured."""
    if not DATABASE_URL:
        return None
    # SQLAlchemy URLs sometimes use the driver-qualified scheme. psycopg2
    # accepts the PostgreSQL URI but not the ``+psycopg2`` suffix.
    if DATABASE_URL.startswith("postgresql+"):
        return "postgresql" + DATABASE_URL[len("postgresql+") :]
    return DATABASE_URL


def _connection_kwargs() -> dict[str, object]:
    """Build connection arguments for installations using discrete DB vars."""
    dsn = _database_dsn()
    if dsn:
        return {"dsn": dsn}

    database = os.getenv("DB_NAME") or os.getenv("PGDATABASE")
    user = os.getenv("DB_USER") or os.getenv("PGUSER")
    if not database or not user:
        raise RuntimeError(
            "Missing database configuration. Set DATABASE_URL or DB_NAME and DB_USER."
        )

    kwargs: dict[str, object] = {
        "host": os.getenv("DB_HOST") or os.getenv("PGHOST", "localhost"),
        "port": int(os.getenv("DB_PORT") or os.getenv("PGPORT", "5432")),
        "database": database,
        "user": user,
        "password": os.getenv("DB_PASS") or os.getenv("PGPASSWORD") or "",
    }
    return kwargs


def _connect():
    kwargs = _connection_kwargs()
    return psycopg2.connect(connect_timeout=5, **kwargs)


def wait_for_db() -> None:
    """Block until PostgreSQL is available or fail with a useful error."""
    last_error: Exception | None = None
    for attempt in range(1, RETRY_COUNT + 1):
        try:
            conn = _connect()
            conn.close()
            print("✅ DB READY", flush=True)
            return
        except Exception as exc:  # pragma: no cover - depends on external DB
            last_error = exc
            print(
                f"⏳ Waiting for DB ({attempt}/{RETRY_COUNT})... {exc}",
                flush=True,
            )
            if attempt < RETRY_COUNT:
                time.sleep(RETRY_DELAY)

    raise RuntimeError(f"Database was not ready after {RETRY_COUNT} attempts: {last_error}")


def run_migrations() -> None:
    """Run the checked-in Alembic revisions and fail startup on errors."""
    env = {**os.environ, "FLASK_APP": "wsgi.py"}
    result = subprocess.run(
        [sys.executable, "-m", "flask", "db", "upgrade"],
        env=env,
        check=False,
    )
    if result.returncode != 0:
        raise RuntimeError(
            "Database migrations failed. See the Alembic output above."
        )
    print("✅ FLASK MIGRATIONS APPLIED", flush=True)


def main() -> int:
    try:
        wait_for_db()
        run_migrations()
    except Exception as exc:
        print(f"❌ Startup database check failed: {exc}", file=sys.stderr, flush=True)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
