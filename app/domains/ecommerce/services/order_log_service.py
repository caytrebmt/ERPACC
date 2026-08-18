from datetime import datetime
from zoneinfo import ZoneInfo

from app.domains.ecommerce.models import OnlineOrder, OrderLog


def _vn_now():
    return datetime.now(ZoneInfo('Asia/Ho_Chi_Minh'))


def add_log(
    order: OnlineOrder,
    action: str,
    status_from: str | None = None,
    status_to: str | None = None,
    message: str | None = None,
    meta: str | None = None,
    created_by: int | None = None,
    created_by_name: str | None = None,
):
    log = OrderLog(
        online_order_id=order.id,
        action=action,
        status_from=status_from,
        status_to=status_to,
        message=message,
        meta=meta,
        created_by=created_by,
        created_by_name=created_by_name,
        created_at=_vn_now(),
    )
    from app.database import db
    db.session.add(log)
    return log


def get_order_logs(order: OnlineOrder):
    return order.logs.order_by(OrderLog.created_at.asc()).all()
