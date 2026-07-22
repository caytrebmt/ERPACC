"""
One-time tool: rebuild inventory quantity + avg_cost from source vouchers.

Usage:
  python scripts/rebuild_inventory_avg_cost.py

Optional:
  python scripts/rebuild_inventory_avg_cost.py --dry-run
"""

from __future__ import annotations

import argparse
import os
import sys
from collections import defaultdict

# Ensure project root is in sys.path when running from scripts/
ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

from app import create_app
from app.database import db
from app.domains.inventory.models import (
    OpeningStock,
    StockIn,
    StockInItem,
    StockOut,
    StockOutItem,
    Inventory,
)


def _f(v):
    return float(v or 0)


def rebuild_inventory(dry_run: bool = True):
    app = create_app()
    with app.app_context():
        events = defaultdict(list)

        # 1) Opening stock (posted)
        for os in OpeningStock.query.filter_by(is_posted=True).all():
            key = (os.product_id, os.warehouse_id)
            events[key].append(
                (
                    os.period_date,
                    0,
                    os.id,
                    "opening",
                    _f(os.quantity),
                    _f(os.unit_cost),
                )
            )

        # 2) Confirmed stock-in (convert to base unit)
        in_rows = db.session.query(StockInItem, StockIn).join(
            StockIn, StockInItem.stock_in_id == StockIn.id
        ).filter(StockIn.status == "confirmed").all()
        for item, doc in in_rows:
            factor = _f(item.conversion_factor) or 1.0
            qty_base = _f(item.quantity) * factor
            unit_cost_base = _f(item.unit_price) / factor
            key = (item.product_id, doc.warehouse_id)
            events[key].append(
                (doc.date, 1, item.id, "stock_in", qty_base, unit_cost_base)
            )

        # 3) Confirmed stock-out (convert to base unit)
        out_rows = db.session.query(StockOutItem, StockOut).join(
            StockOut, StockOutItem.stock_out_id == StockOut.id
        ).filter(StockOut.status == "confirmed").all()
        for item, doc in out_rows:
            factor = _f(item.conversion_factor) or 1.0
            qty_base = _f(item.quantity) * factor
            key = (item.product_id, doc.warehouse_id)
            events[key].append((doc.date, 2, item.id, "stock_out", qty_base, 0.0))

        updated = 0
        for (product_id, warehouse_id), rows in events.items():
            rows.sort(key=lambda x: (x[0], x[1], x[2]))
            qty = 0.0
            avg = 0.0
            for _, _, _, kind, amount_qty, unit_cost in rows:
                if kind in ("opening", "stock_in"):
                    new_qty = qty + amount_qty
                    if new_qty > 0:
                        avg = ((qty * avg) + (amount_qty * unit_cost)) / new_qty
                    else:
                        avg = unit_cost
                    qty = new_qty
                else:
                    qty -= amount_qty

            inv = Inventory.query.filter_by(
                product_id=product_id, warehouse_id=warehouse_id
            ).first()
            if not inv:
                inv = Inventory(product_id=product_id, warehouse_id=warehouse_id)
                db.session.add(inv)
            inv.quantity = qty
            inv.avg_cost = avg
            updated += 1

        if dry_run:
            db.session.rollback()
            print(f"[DRY RUN] Rebuild preview done. Rows evaluated: {updated}")
        else:
            db.session.commit()
            print(f"[DONE] Inventory rebuilt. Rows updated: {updated}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true", help="Preview only, no commit")
    args = parser.parse_args()
    rebuild_inventory(dry_run=args.dry_run)
