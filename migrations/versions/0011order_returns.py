"""add return fields to online_orders

Allows customers to request returns for delivered orders and
for ERP admins to process those returns by creating Stock In documents.

Revision ID: 0011order_returns
Revises: 51c6e6a1fb16
"""
from alembic import op
import sqlalchemy as sa

revision = '0011order_returns'
down_revision = '51c6e6a1fb16'
branch_labels = None
depends_on = None


def upgrade():
    op.execute(sa.text("""
        ALTER TABLE online_orders
        ADD COLUMN IF NOT EXISTS return_status VARCHAR(20) DEFAULT 'none' NOT NULL,
        ADD COLUMN IF NOT EXISTS return_requested_at TIMESTAMP NULL,
        ADD COLUMN IF NOT EXISTS return_processed_at TIMESTAMP NULL,
        ADD COLUMN IF NOT EXISTS return_note TEXT NULL,
        ADD COLUMN IF NOT EXISTS stock_in_id INTEGER NULL,
        ADD COLUMN IF NOT EXISTS returned_at TIMESTAMP NULL
    """))
    op.execute(sa.text("""
        DO $$
        BEGIN
            IF NOT EXISTS (
                SELECT 1 FROM pg_constraint WHERE conname = 'fk_online_orders_stock_in_id'
            ) THEN
                ALTER TABLE online_orders
                ADD CONSTRAINT fk_online_orders_stock_in_id
                FOREIGN KEY (stock_in_id) REFERENCES stock_ins(id);
            END IF;
        END;
        $$
    """))
    op.execute(sa.text(
        "COMMENT ON COLUMN online_orders.return_status IS 'Trạng thái yêu cầu trả hàng: none, requested, approved, rejected, completed'"
    ))
    op.execute(sa.text(
        "COMMENT ON COLUMN online_orders.return_requested_at IS 'Thời gian khách yêu cầu trả hàng'"
    ))
    op.execute(sa.text(
        "COMMENT ON COLUMN online_orders.return_processed_at IS 'Thời gian admin xử lý yêu cầu'"
    ))
    op.execute(sa.text(
        "COMMENT ON COLUMN online_orders.return_note IS 'Ghi chú xử lý trả hàng'"
    ))
    op.execute(sa.text(
        "COMMENT ON COLUMN online_orders.stock_in_id IS 'ID phiếu nhập kho tạo từ đơn trả hàng'"
    ))
    op.execute(sa.text(
        "COMMENT ON COLUMN online_orders.returned_at IS 'Thời gian hoàn tất trả hàng và nhập kho'"
    ))


def downgrade():
    op.execute(sa.text(
        "ALTER TABLE online_orders DROP CONSTRAINT IF EXISTS fk_online_orders_stock_in_id"
    ))
    op.execute(sa.text("""
        ALTER TABLE online_orders
        DROP COLUMN IF EXISTS return_status,
        DROP COLUMN IF EXISTS return_requested_at,
        DROP COLUMN IF EXISTS return_processed_at,
        DROP COLUMN IF EXISTS return_note,
        DROP COLUMN IF EXISTS stock_in_id,
        DROP COLUMN IF EXISTS returned_at
    """))
