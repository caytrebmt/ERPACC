from flask import Blueprint, request, jsonify
from flask_login import login_required, current_user
from app.database import db
from app.domains.ecommerce.models import WebCustomer
from app.shared.authz import require_permission

shop_customers_bp = Blueprint('shop_customers', __name__, url_prefix='/api/erp/shop-customers')


def _serialize_customer(c):
    return {
        'id': c.id,
        'email': c.email,
        'name': c.name,
        'phone': c.phone,
        'role': c.role,
        'is_active': bool(c.is_active),
        'customer_id': c.customer_id,
        'plain_password': c.plain_password or '',
        'created_at': c.created_at.isoformat() if c.created_at else None,
        'last_login': c.last_login.isoformat() if c.last_login else None,
    }


@shop_customers_bp.get('')
@login_required
@require_permission('ecommerce', 'view')
def list_shop_customers():
    search = (request.args.get('search', '') or '').strip()
    page = request.args.get('page', 1, type=int)
    per_page = min(request.args.get('per_page', 20, type=int) or 20, 100)

    q = WebCustomer.query
    if search:
        pattern = f'%{search}%'
        q = q.filter(db.or_(
            WebCustomer.email.ilike(pattern),
            WebCustomer.name.ilike(pattern),
            WebCustomer.phone.ilike(pattern),
        ))

    q = q.order_by(WebCustomer.created_at.desc())
    total = q.count()
    items = q.offset((page - 1) * per_page).limit(per_page).all()

    return jsonify({
        'ok': True,
        'data': {
            'items': [_serialize_customer(c) for c in items],
            'total': total,
            'page': page,
            'per_page': per_page,
            'pages': max(1, (total + per_page - 1) // per_page) if total else 1,
        }
    })


@shop_customers_bp.get('/<int:customer_id>')
@login_required
@require_permission('ecommerce', 'view')
def get_shop_customer(customer_id):
    c = WebCustomer.query.get_or_404(customer_id)
    return jsonify({'ok': True, 'data': _serialize_customer(c)})


@shop_customers_bp.post('')
@login_required
@require_permission('ecommerce', 'create')
def create_shop_customer():
    payload = request.get_json(silent=True) or {}
    email = (payload.get('email') or '').strip().lower()
    name = (payload.get('name') or '').strip()
    phone = (payload.get('phone') or '').strip()
    password = payload.get('password') or ''
    is_active = payload.get('is_active', True)

    if not email or not name:
        return jsonify({'ok': False, 'message': 'Email va ten khong duoc de trong.'}), 400
    if not password:
        return jsonify({'ok': False, 'message': 'Mat khau khong duoc de trong.'}), 400
    if WebCustomer.query.filter_by(email=email).first():
        return jsonify({'ok': False, 'message': 'Email nay da duoc dang ky.'}), 409

    c = WebCustomer(email=email, name=name, phone=phone, is_active=bool(is_active))
    c.set_password(password, store_plain=True)
    db.session.add(c)
    db.session.commit()

    return jsonify({'ok': True, 'data': _serialize_customer(c), 'message': 'Tao tai khoan khach hang thanh cong.'})


@shop_customers_bp.put('/<int:customer_id>')
@login_required
@require_permission('ecommerce', 'edit')
def update_shop_customer(customer_id):
    c = WebCustomer.query.get_or_404(customer_id)
    payload = request.get_json(silent=True) or {}

    c.name = (payload.get('name') or c.name).strip()
    c.phone = (payload.get('phone') or c.phone).strip()
    c.email = (payload.get('email') or c.email).strip().lower()
    c.is_active = bool(payload.get('is_active', c.is_active))

    if payload.get('password'):
        c.set_password(payload['password'], store_plain=True)

    db.session.commit()
    return jsonify({'ok': True, 'data': _serialize_customer(c), 'message': 'Cap nhat thanh cong.'})


@shop_customers_bp.delete('/<int:customer_id>')
@login_required
@require_permission('ecommerce', 'delete')
def delete_shop_customer(customer_id):
    c = WebCustomer.query.get_or_404(customer_id)
    db.session.delete(c)
    db.session.commit()
    return jsonify({'ok': True, 'message': 'Da xoa tai khoan khach hang.'})


@shop_customers_bp.put('/<int:customer_id>/toggle')
@login_required
@require_permission('ecommerce', 'edit')
def toggle_shop_customer(customer_id):
    c = WebCustomer.query.get_or_404(customer_id)
    c.is_active = not c.is_active
    db.session.commit()
    return jsonify({'ok': True, 'data': _serialize_customer(c), 'message': 'Cap nhat trang thai thanh cong.'})
