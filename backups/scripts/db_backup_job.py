"""
Scheduled DB backup job for production.

Usage:
  python scripts/db_backup_job.py --format custom --keep-days 14
  python scripts/db_backup_job.py --format plain --keep-days 7
"""

from __future__ import annotations

import argparse
import datetime
import os
import subprocess
from pathlib import Path


def _build_conn():
    db_url = os.getenv("DATABASE_URL", "")
    if not db_url:
        raise RuntimeError("DATABASE_URL is empty.")
    # Lazy parse using SQLAlchemy URL parser already available in project deps.
    from sqlalchemy.engine import make_url

    uri = make_url(db_url)
    return {
        "user": uri.username or "",
        "password": uri.password or "",
        "host": uri.host or "localhost",
        "port": uri.port or 5432,
        "database": uri.database or "",
    }


def _resolve(bin_name: str) -> str:
    env_map = {
        "pg_dump": "PG_DUMP_PATH",
        "pg_restore": "PG_RESTORE_PATH",
    }
    p = (os.getenv(env_map.get(bin_name, ""), "") or "").strip()
    if p and os.path.exists(p):
        return p
    return bin_name


def _cleanup(backup_dir: Path, keep_days: int):
    cutoff = datetime.datetime.now() - datetime.timedelta(days=max(1, keep_days))
    for f in backup_dir.glob("*"):
        if not f.is_file():
            continue
        try:
            if datetime.datetime.fromtimestamp(f.stat().st_mtime) < cutoff:
                f.unlink(missing_ok=True)
        except Exception:
            pass


def run_backup(fmt: str, keep_days: int):
    info = _build_conn()
    backup_dir = Path(os.getenv("BACKUP_DIR", "backups"))
    backup_dir.mkdir(parents=True, exist_ok=True)
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    ext = "dump" if fmt == "custom" else "sql"
    target = backup_dir / f"{info['database']}_{ts}.{ext}"

    env = os.environ.copy()
    if info["password"]:
        env["PGPASSWORD"] = info["password"]

    cmd = [
        _resolve("pg_dump"),
        "-h",
        info["host"],
        "-p",
        str(info["port"]),
        "-U",
        info["user"],
        "-F",
        "c" if fmt == "custom" else "p",
        "-f",
        str(target),
        info["database"],
    ]
    subprocess.check_call(cmd, env=env)
    _cleanup(backup_dir, keep_days)
    print(f"[OK] backup created: {target}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--format", choices=["plain", "custom"], default="custom")
    parser.add_argument("--keep-days", type=int,
                        default=int(os.getenv("BACKUP_KEEP_DAYS", "14")))
    args = parser.parse_args()
    run_backup(args.format, args.keep_days)
