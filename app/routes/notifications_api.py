from flask import Blueprint, request, jsonify
from flask_login import login_required, current_user
from app.core.extensions import csrf
from app.database import db
from app.domains.platform.models import NotificationInstance

erp_notifications_bp = Blueprint('erp_notifications', __name__, url_prefix='/api/erp/notifications')
csrf.exempt(erp_notifications_bp)


def _serialize_notification(n):
    return {
        'id': n.id,
        'user_id': n.user_id,
        'title': n.title,
        'message': n.message,
        'noti_type': n.noti_type,
        'module': n.module,
        'reference_id': n.reference_id,
        'reference_type': n.reference_type,
        'is_read': bool(n.is_read),
        'created_at': n.created_at.isoformat() if n.created_at else None,
    }


@erp_notifications_bp.get('')
@login_required
def list_notifications():
    page = request.args.get('page', 1, type=int)
    per_page = min(request.args.get('per_page', 20, type=int) or 20, 100)
    unread_only = request.args.get('unread_only') == '1'

    q = NotificationInstance.query.filter_by(user_id=current_user.id)
    if unread_only:
        q = q.filter(NotificationInstance.is_read == False)

    q = q.order_by(NotificationInstance.created_at.desc())
    total = q.count()
    items = q.offset((page - 1) * per_page).limit(per_page).all()

    return jsonify({
        'ok': True,
        'data': {
            'items': [_serialize_notification(n) for n in items],
            'total': total,
            'page': page,
            'per_page': per_page,
            'pages': max(1, (total + per_page - 1) // per_page) if total else 1,
        }
    })


@erp_notifications_bp.get('/unread-count')
@login_required
def unread_count():
    count = NotificationInstance.query.filter_by(user_id=current_user.id, is_read=False).count()
    return jsonify({'ok': True, 'data': {'count': count}})


@erp_notifications_bp.put('/<int:notif_id>/read')
@login_required
def mark_read(notif_id):
    n = NotificationInstance.query.get_or_404(notif_id)
    if n.user_id != current_user.id:
        return jsonify({'ok': False, 'message': 'Khong co quyen.'}), 403
    n.is_read = True
    db.session.commit()
    return jsonify({'ok': True, 'data': _serialize_notification(n)})


@erp_notifications_bp.put('/read-all')
@login_required
def mark_all_read():
    NotificationInstance.query.filter_by(user_id=current_user.id, is_read=False).update({'is_read': True})
    db.session.commit()
    return jsonify({'ok': True, 'message': 'Da danh dau het thong bao da doc.'})


@erp_notifications_bp.post('')
@login_required
def create_notification():
    if current_user.role != 'admin':
        return jsonify({'ok': False, 'message': 'Chi admin moi co quyen tao thong bao.'}), 403

    payload = request.get_json(silent=True) or {}
    title = (payload.get('title') or '').strip()
    message = (payload.get('message') or '').strip()
    noti_type = (payload.get('noti_type') or 'info').strip()
    module = (payload.get('module') or '').strip() or None
    reference_id = payload.get('reference_id')
    reference_type = (payload.get('reference_type') or '').strip() or None
    user_id = payload.get('user_id')

    if not title or not message:
        return jsonify({'ok': False, 'message': 'Tieu de va noi dung khong duoc de trong.'}), 400

    target_user_id = user_id if user_id else current_user.id
    n = NotificationInstance(
        user_id=target_user_id,
        title=title,
        message=message,
        noti_type=noti_type,
        module=module,
        reference_id=reference_id,
        reference_type=reference_type,
    )
    db.session.add(n)
    db.session.commit()
    return jsonify({'ok': True, 'data': _serialize_notification(n), 'message': 'Tao thong bao thanh cong.'})
