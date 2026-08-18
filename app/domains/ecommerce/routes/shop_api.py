from __future__ import annotations

from datetime import datetime, timedelta

from flask import Blueprint, jsonify, request, current_app
from flask_jwt_extended import (
    create_access_token,
    create_refresh_token,
    get_jwt_identity,
    jwt_required,
)
from flask_login import current_user

from app.core.extensions import csrf
from app.database import db
from app.domains.ecommerce.models import (
    Cart,
    CartItem,
    CustomerSession,
    OnlineOrder,
    OnlineOrderItem,
    ProductListing,
    Promotion,
    WebCustomer,
)
from app.domains.ecommerce.services.order_log_service import add_log as add_order_log
from app.domains.master.models import Category, Customer, Product
from app.domains.platform.models import NotificationInstance
from app.domains.ecommerce.services.ecommerce_sync_service import (
    generate_online_order_code,
    generate_tracking_token,
    listing_query,
)
from app.domains.ecommerce.routes.ecommerce import _broadcast

shop_api_bp = Blueprint('shop_api', __name__, url_prefix='/api/shop')
csrf.exempt(shop_api_bp)

_SHOP_LOGIN_FAILS = {}
_SHOP_MAX_FAILS = 5
_SHOP_LOCK_MINUTES = 10
_SHOP_FAIL_TIMEOUT = 600


def _shop_rate_limit_key(ip, email):
    return f'shop_login_fail:{ip}:{email}'


def _shop_check_lock(ip, email):
    try:
        from app.core.extensions import cache
        data = cache.get(_shop_rate_limit_key(ip, email))
        if data and data.get('lock_until') and datetime.utcnow() < data['lock_until']:
            return True, data
        return False, data or {'count': 0}
    except Exception:
        key = f'{ip}:{email}'
        data = _SHOP_LOGIN_FAILS.get(key, {'count': 0, 'lock_until': None})
        if data.get('lock_until') and datetime.utcnow() < data['lock_until']:
            return True, data
        return False, data


def _shop_record_fail(ip, email):
    try:
        from app.core.extensions import cache
        data = {'count': 1, 'lock_until': None}
        key = _shop_rate_limit_key(ip, email)
        existing = cache.get(key)
        if existing:
            data['count'] = existing.get('count', 0) + 1
        if data['count'] >= _SHOP_MAX_FAILS:
            data['lock_until'] = datetime.utcnow() + timedelta(minutes=_SHOP_LOCK_MINUTES)
            data['count'] = 0
        cache.set(key, data, timeout=_SHOP_FAIL_TIMEOUT)
    except Exception:
        key = f'{ip}:{email}'
        data = _SHOP_LOGIN_FAILS.get(key, {'count': 0, 'lock_until': None})
        data['count'] = data.get('count', 0) + 1
        if data['count'] >= _SHOP_MAX_FAILS:
            data['lock_until'] = datetime.utcnow() + timedelta(minutes=_SHOP_LOCK_MINUTES)
            data['count'] = 0
        _SHOP_LOGIN_FAILS[key] = data


def _num(v, default=0.0):
    try:
        return float(v or default)
    except Exception:
        return float(default)

def _resolve_image_url(image_url):
    if not image_url:
        return ''
    if image_url.startswith(('http://', 'https://')):
        return image_url
    backend_url = current_app.config.get('SHOP_BACKEND_URL')
    if backend_url and image_url.startswith('/'):
        return f'{backend_url}{image_url}'
    return image_url

def _json_ok(data=None, message='', status=200):
    payload = {'ok': True}
    if data is not None:
        payload['data'] = data
    if message:
        payload['message'] = message
    return jsonify(payload), status


def _json_err(message, status=400):
    return jsonify({'ok': False, 'message': message}), status


def _notify_admins(title, message, noti_type='info', module='ecommerce', reference_id=None, reference_type=None):
    try:
        from app.models.system import User
        admins = User.query.filter_by(role='admin', is_active=True).all()
        if not admins:
            current_app.logger.warning('_notify_admins: no active admin users found')
            return
        for admin in admins:
            n = NotificationInstance(
                user_id=admin.id,
                title=title,
                message=message,
                noti_type=noti_type,
                module=module,
                reference_id=reference_id,
                reference_type=reference_type,
            )
            db.session.add(n)
        db.session.commit()
    except Exception:
        db.session.rollback()
        current_app.logger.exception('_notify_admins failed')


def _ensure_erp_customer_for_web(web_customer: WebCustomer) -> Customer:
    filters = []
    if web_customer.email:
        filters.append(Customer.email == web_customer.email)
    if web_customer.phone:
        filters.append(Customer.phone == web_customer.phone)
    if filters:
        existing = Customer.query.filter(db.or_(*filters)).first()
        if existing:
            web_customer.customer_id = existing.id
            return existing
    if web_customer.customer_id:
        if web_customer.customer:
            return web_customer.customer
        customer = Customer.query.get(web_customer.customer_id)
        if customer:
            return customer
    code = f'WEB-{web_customer.id}'
    while Customer.query.filter_by(code=code).first():
        code = f'WEB-{web_customer.id}-{__import__("random").randint(100, 999)}'
    customer = Customer(
        code=code,
        name=web_customer.name,
        short_name=web_customer.name,
        customer_type='retail',
        phone=web_customer.phone,
        email=web_customer.email,
        address='',
    )
    db.session.add(customer)
    db.session.flush()
    web_customer.customer_id = customer.id
    return customer


def _get_web_customer_from_jwt():
    try:
        from flask_jwt_extended import verify_jwt_in_request, get_jwt_identity
        verify_jwt_in_request(optional=True)
        identity = get_jwt_identity()
        if not identity:
            return None
        return WebCustomer.query.get(int(identity))
    except Exception:
        return None


def _get_or_create_customer_session_for_web_customer(web_customer):
    cs = CustomerSession.query.filter_by(
        session_key=f'jwt:{web_customer.id}'
    ).first()
    if not cs:
        cs = CustomerSession(
            session_key=f'jwt:{web_customer.id}',
            customer_id=web_customer.customer_id,
            name=web_customer.name,
            email=web_customer.email,
            phone=web_customer.phone,
        )
        db.session.add(cs)
        db.session.flush()
    cs.last_seen_at = datetime.utcnow()
    return cs


def _active_cart_for_session(customer_session):
    cart = Cart.query.filter_by(session_id=customer_session.id, status='active').first()
    if not cart:
        cart = Cart(session_id=customer_session.id, customer_id=customer_session.customer_id)
        db.session.add(cart)
        db.session.flush()
    return cart


def _get_or_create_shop_customer_session():
    from flask import session as flask_session
    key = flask_session.get('shop_session_key')
    if not key:
        import uuid
        key = uuid.uuid4().hex
        flask_session['shop_session_key'] = key
    cs = CustomerSession.query.filter_by(session_key=key).first()
    if not cs:
        cs = CustomerSession(session_key=key)
        db.session.add(cs)
        db.session.flush()
    if current_user.is_authenticated and isinstance(current_user._get_current_object(), WebCustomer):
        cs.customer_id = current_user.customer_id
        cs.name = getattr(current_user, 'name', None) or getattr(current_user, 'full_name', None)
        cs.email = current_user.email
        cs.phone = current_user.phone
    cs.last_seen_at = datetime.utcnow()
    return cs


def _active_cart():
    cs = _get_or_create_shop_customer_session()
    return _active_cart_for_session(cs)


# ===================== AUTH =====================

@shop_api_bp.post('/auth/login')
def auth_login():
    payload = request.get_json(silent=True) or {}
    email = (payload.get('email') or '').strip().lower()
    password = payload.get('password') or ''
    ip = (request.headers.get('X-Forwarded-For', request.remote_addr) or 'unknown').split(',')[0].strip()
    if not email or not password:
        return _json_err('Vui lòng nhập email và mật khẩu.', 400)

    is_locked, fail_info = _shop_check_lock(ip, email)
    if is_locked:
        left = int((fail_info['lock_until'] - datetime.utcnow()).total_seconds() // 60) + 1
        return _json_err(f'Tài khoản tạm khóa. Vui lòng thử lại sau {left} phút.', 429)

    web_customer = WebCustomer.query.filter_by(email=email, is_active=True).first()
    if not web_customer or not web_customer.check_password(password):
        _shop_record_fail(ip, email)
        return _json_err('Email hoặc mật khẩu không đúng.', 401)
    try:
        from app.core.extensions import cache
        cache.delete(_shop_rate_limit_key(ip, email))
    except Exception:
        _SHOP_LOGIN_FAILS.pop(f'{ip}:{email}', None)
    web_customer.last_login = datetime.utcnow()
    db.session.commit()
    identity = str(web_customer.id)
    access_token = create_access_token(identity=identity, additional_claims={'role': 'web_customer'})
    refresh_token = create_refresh_token(identity=identity)
    return _json_ok({
        'access_token': access_token,
        'refresh_token': refresh_token,
        'customer': {
            'id': web_customer.id,
            'name': web_customer.name,
            'email': web_customer.email,
            'phone': web_customer.phone,
            'customer_id': web_customer.customer_id,
        }
    }, message='Đăng nhập thành công.')


@shop_api_bp.post('/auth/register')
def auth_register():
    payload = request.get_json(silent=True) or {}
    name = (payload.get('name') or '').strip()
    email = (payload.get('email') or '').strip().lower()
    phone = (payload.get('phone') or '').strip()
    password = payload.get('password') or ''
    confirm = payload.get('confirmPassword') or payload.get('confirm_password') or ''
    ip = (request.headers.get('X-Forwarded-For', request.remote_addr) or 'unknown').split(',')[0].strip()

    is_locked, fail_info = _shop_check_lock(ip, email)
    if is_locked:
        left = int((fail_info['lock_until'] - datetime.utcnow()).total_seconds() // 60) + 1
        return _json_err(f'Quá nhiều lần đăng ký. Vui lòng thử lại sau {left} phút.', 429)

    if not name or not email or not password:
        return _json_err('Vui lòng nhập đầy đủ họ tên, email và mật khẩu.', 400)
    if password != confirm:
        return _json_err('Mật khẩu xác nhận không khớp.', 400)
    if len(password) < 8:
        return _json_err('Mật khẩu tối thiểu 8 ký tự.', 400)
    if WebCustomer.query.filter_by(email=email).first():
        return _json_err('Email này đã được đăng ký.', 409)
    customer_id = None
    filters = [Customer.email == email]
    if phone:
        filters.append(Customer.phone == phone)
    existing = Customer.query.filter(db.or_(*filters)).first()
    if existing:
        customer_id = existing.id
    web_customer = WebCustomer(
        customer_id=customer_id,
        email=email,
        name=name,
        phone=phone,
    )
    web_customer.set_password(password, store_plain=True)
    db.session.add(web_customer)
    db.session.commit()
    _ensure_erp_customer_for_web(web_customer)
    db.session.commit()
    try:
        from app.core.extensions import cache
        cache.delete(_shop_rate_limit_key(ip, email))
    except Exception:
        _SHOP_LOGIN_FAILS.pop(f'{ip}:{email}', None)
    identity = str(web_customer.id)
    access_token = create_access_token(identity=identity, additional_claims={'role': 'web_customer'})
    refresh_token = create_refresh_token(identity=identity)
    return _json_ok({
        'access_token': access_token,
        'refresh_token': refresh_token,
        'customer': {
            'id': web_customer.id,
            'name': web_customer.name,
            'email': web_customer.email,
            'phone': web_customer.phone,
            'customer_id': web_customer.customer_id,
        }
    }, message='Tạo tài khoản thành công.')


@shop_api_bp.post('/auth/refresh')
@jwt_required(refresh=True)
def auth_refresh():
    identity = get_jwt_identity()
    access_token = create_access_token(identity=identity, additional_claims={'role': 'web_customer'})
    return _json_ok({'access_token': access_token})


@shop_api_bp.get('/auth/google')
def auth_google_redirect():
    from urllib.parse import urlencode
    from flask import current_app
    client_id = current_app.config.get('GOOGLE_OAUTH_CLIENT_ID')
    redirect_uri = current_app.config.get('GOOGLE_OAUTH_REDIRECT_URI')
    if not client_id or not redirect_uri:
        return _json_err('Google OAuth chưa được cấu hình.', 500)
    params = {
        'client_id': client_id,
        'redirect_uri': redirect_uri,
        'response_type': 'code',
        'scope': 'openid email profile',
        'access_type': 'offline',
        'prompt': 'consent',
    }
    return jsonify({'ok': True, 'data': {'auth_url': f'https://accounts.google.com/o/oauth2/v2/auth?{urlencode(params)}'}})


@shop_api_bp.route('/auth/google/callback', methods=['GET', 'POST'])
def auth_google_callback():
    if request.method == 'GET':
        code = request.args.get('code', '').strip()
    else:
        payload = request.get_json(silent=True) or {}
        code = (payload.get('code') or '').strip()
    if not code:
        return _json_err('Thiếu mã xác thực Google.', 400)

    from flask import current_app
    client_id = current_app.config.get('GOOGLE_OAUTH_CLIENT_ID')
    client_secret = current_app.config.get('GOOGLE_OAUTH_CLIENT_SECRET')
    redirect_uri = current_app.config.get('GOOGLE_OAUTH_REDIRECT_URI')
    if not client_id or not client_secret or not redirect_uri:
        return _json_err('Google OAuth chưa được cấu hình.', 500)

    import requests as req_lib
    token_resp = req_lib.post('https://oauth2.googleapis.com/token', data={
        'code': code,
        'client_id': client_id,
        'client_secret': client_secret,
        'redirect_uri': redirect_uri,
        'grant_type': 'authorization_code',
    })
    if token_resp.status_code != 200:
        return _json_err('Không thể xác thực với Google.', 400)
    token_json = token_resp.json()
    id_token = token_json.get('id_token')
    if not id_token:
        return _json_err('Thiếu id_token từ Google.', 400)

    import jwt as pyjwt
    from jwt import PyJWKClient
    jwks_url = 'https://www.googleapis.com/oauth2/v3/certs'
    jwk_client = PyJWKClient(jwks_url)
    signing_key = jwk_client.get_signing_key_from_jwt(id_token)
    client_id = current_app.config.get('GOOGLE_OAUTH_CLIENT_ID', '')
    payload_jwt = pyjwt.decode(id_token, signing_key.key, algorithms=['RS256'], audience=client_id)
    google_email = (payload_jwt.get('email') or '').strip().lower()
    google_name = (payload_jwt.get('name') or '').strip()
    google_picture = payload_jwt.get('picture')
    if not google_email:
        return _json_err('Không lấy được email từ Google.', 400)

    web_customer = WebCustomer.query.filter_by(email=google_email).first()
    if not web_customer:
        customer_id = None
        existing = Customer.query.filter_by(email=google_email).first()
        if existing:
            customer_id = existing.id
        web_customer = WebCustomer(
            customer_id=customer_id,
            email=google_email,
            name=google_name,
            phone='',
        )
        db.session.add(web_customer)
        db.session.flush()
        _ensure_erp_customer_for_web(web_customer)
        db.session.commit()

    web_customer.last_login = datetime.utcnow()
    db.session.commit()
    identity = str(web_customer.id)
    access_token = create_access_token(identity=identity, additional_claims={'role': 'web_customer'})
    refresh_token = create_refresh_token(identity=identity)
    return _json_ok({
        'access_token': access_token,
        'refresh_token': refresh_token,
        'customer': {
            'id': web_customer.id,
            'name': web_customer.name,
            'email': web_customer.email,
            'phone': web_customer.phone,
            'customer_id': web_customer.customer_id,
            'picture': google_picture,
        }
    }, message='Đăng nhập Google thành công.')


# ===================== CATALOG =====================

@shop_api_bp.get('/catalog')
def catalog():
    search = request.args.get('search', '')
    category_id = request.args.get('category_id', type=int)
    page = request.args.get('page', 1, type=int)
    per_page = min(request.args.get('per_page', 24, type=int), 100)

    q = listing_query(search, True)
    if category_id:
        q = q.filter(Product.category_id == category_id)
    pagination = q.order_by(ProductListing.id.desc()).paginate(
        page=page, per_page=per_page, error_out=False
    )

    products = []
    for l in pagination.items:
        p = l.product
        stock = float(getattr(l, 'stock_cached', 0) or 0)
        product_specs = ''
        product_brand = ''
        product_compare_at = None
        if p:
            specs_raw = getattr(p, 'specifications', None) or getattr(p, 'specs', None) or ''
            product_specs = specs_raw if isinstance(specs_raw, str) else str(specs_raw)
            product_brand = getattr(p, 'brand', '') or ''
            product_compare_at = float(getattr(p, 'compare_at_price', 0) or getattr(l, 'compare_at_price', 0) or 0)
        products.append({
            'id': p.id if p else l.id,
            'listing_id': l.id,
            'sku': getattr(p, 'code', '') or '',
            'name': l.display_name() if hasattr(l, 'display_name') else getattr(p, 'name', ''),
            'description': getattr(p, 'description', '') or getattr(l, 'web_description', '') or '',
            'imageUrl': _resolve_image_url(getattr(l, 'display_image', None) or getattr(l, 'image_url', None) or ''),
            'salePrice': float(l.display_retail_price() if hasattr(l, 'display_retail_price') else getattr(l, 'web_price', 0) or 0),
            'contactForPrice': bool(getattr(l, 'contact_for_price', False)),
            'isFlashSale': False,
            'flashSalePrice': None,
            'stock': stock,
            'minStock': 0,
            'serialNumbers': [],
            'categoryId': getattr(p, 'category_id', None) or None,
            'unit': getattr(p, 'unit', '') or '',
            'slug': l.slug,
            'specs': product_specs,
            'brand': product_brand,
            'compareAtPrice': product_compare_at if product_compare_at > 0 else None,
        })

    return _json_ok({
        'products': products,
        'total': pagination.total,
        'page': page,
        'per_page': per_page,
        'pages': pagination.pages,
    })


@shop_api_bp.get('/categories')
def list_categories():
    categories = []
    try:
        cats = Category.query.filter_by(is_active=True).order_by(Category.name.asc()).all()
        categories = [{'id': c.id, 'code': c.code, 'name': c.name} for c in cats]
    except Exception:
        pass
    return _json_ok({'categories': categories})


@shop_api_bp.get('/products/<product_id>')
def product_detail(product_id):
    listing = None
    try:
        pid = int(product_id)
        listing = ProductListing.query.filter_by(product_id=pid, is_published=True).first()
    except ValueError:
        listing = ProductListing.query.filter_by(slug=product_id, is_published=True).first()
    if not listing:
        return _json_err('Không tìm thấy sản phẩm.', 404)
    p = listing.product
    stock = float(getattr(listing, 'stock_cached', 0) or 0)
    product_specs = ''
    product_brand = ''
    product_compare_at = None
    if p:
        specs_raw = getattr(p, 'specifications', None) or getattr(p, 'specs', None) or ''
        product_specs = specs_raw if isinstance(specs_raw, str) else str(specs_raw)
        product_brand = getattr(p, 'brand', '') or ''
        product_compare_at = float(getattr(p, 'compare_at_price', 0) or getattr(listing, 'compare_at_price', 0) or 0)
    data = {
        'id': p.id if p else listing.id,
        'listing_id': listing.id,
        'sku': getattr(p, 'code', '') or '',
        'name': listing.display_name() if hasattr(listing, 'display_name') else getattr(p, 'name', ''),
        'description': getattr(p, 'description', '') or getattr(listing, 'web_description', '') or '',
        'imageUrl': _resolve_image_url(getattr(listing, 'display_image', None) or getattr(listing, 'image_url', None) or ''),
        'salePrice': float(listing.display_retail_price() if hasattr(listing, 'display_retail_price') else getattr(listing, 'web_price', 0) or 0),
        'contactForPrice': bool(getattr(listing, 'contact_for_price', False)),
        'stock': stock,
        'categoryId': getattr(p, 'category_id', None) or None,
        'unit': getattr(p, 'unit', '') or '',
        'slug': listing.slug,
        'specs': product_specs,
        'brand': product_brand,
        'compareAtPrice': product_compare_at if product_compare_at > 0 else None,
    }
    return _json_ok(data)


# ===================== CART =====================

def _get_cart_for_current_user():
    web_customer = _get_web_customer_from_jwt()
    if web_customer:
        cs = _get_or_create_customer_session_for_web_customer(web_customer)
        return _active_cart_for_session(cs)
    cs = _get_or_create_shop_customer_session()
    return _active_cart_for_session(cs)


def _serialize_cart(cart):
    items = []
    subtotal = 0.0
    for item in cart.items:
        qty = float(item.quantity or 0)
        price = float(item.unit_price or 0)
        amount = qty * price
        subtotal += amount
        product = item.product
        listing = item.listing
        items.append({
            'id': item.id,
            'listing_id': item.listing_id,
            'product_id': item.product_id,
            'name': (listing.display_name() if listing and hasattr(listing, 'display_name') else (product.name if product else 'Sản phẩm')),
            'sku': (product.code if product else ''),
            'slug': (listing.slug if listing and hasattr(listing, 'slug') else (product.slug if product else '')),
            'imageUrl': _resolve_image_url((listing.display_image if listing and hasattr(listing, 'display_image') else (product.main_image if product else None))),
            'unit_price': price,
            'quantity': qty,
            'amount': amount,
            'unit': (product.unit if product else 'Cái'),
        })
    return {
        'cart_id': cart.id,
        'items': items,
        'subtotal': subtotal,
        'total': subtotal,
        'item_count': len(items),
    }


@shop_api_bp.get('/cart')
def get_cart():
    cart = _get_cart_for_current_user()
    return _json_ok(_serialize_cart(cart))


@shop_api_bp.post('/cart/items')
def add_cart_item():
    cart = _get_cart_for_current_user()
    payload = request.get_json(silent=True) or {}
    listing_id = payload.get('listing_id') or payload.get('listingId')
    product_id = payload.get('product_id') or payload.get('productId')
    quantity = max(int(payload.get('quantity') or 1), 1)
    if not listing_id and not product_id:
        return _json_err('Thiếu listing_id hoặc product_id.', 400)
    listing = None
    if listing_id:
        listing = ProductListing.query.filter_by(id=listing_id, is_published=True).first()
    if not listing and product_id:
        listing = ProductListing.query.filter_by(product_id=product_id, is_published=True).first()
    if not listing:
        return _json_err('Sản phẩm không tồn tại hoặc chưa xuất bản.', 404)
    price = listing.display_retail_price()
    existing = CartItem.query.filter_by(cart_id=cart.id, listing_id=listing.id).first()
    if existing:
        existing.quantity = float(existing.quantity or 0) + quantity
        existing.unit_price = price
    else:
        db.session.add(CartItem(
            cart_id=cart.id,
            listing_id=listing.id,
            product_id=listing.product_id,
            quantity=quantity,
            unit_price=price,
        ))
    db.session.commit()
    return _json_ok(_serialize_cart(cart), message='Đã thêm vào giỏ hàng.')


@shop_api_bp.put('/cart/items/<int:item_id>')
def update_cart_item(item_id):
    cart = _get_cart_for_current_user()
    item = CartItem.query.filter_by(id=item_id, cart_id=cart.id).first_or_404()
    payload = request.get_json(silent=True) or {}
    quantity = payload.get('quantity')
    if quantity is None:
        return _json_err('Thiếu quantity.', 400)
    quantity = max(float(quantity), 0)
    if quantity <= 0:
        db.session.delete(item)
    else:
        item.quantity = quantity
    db.session.commit()
    return _json_ok(_serialize_cart(cart))


@shop_api_bp.delete('/cart/items/<int:item_id>')
def delete_cart_item(item_id):
    cart = _get_cart_for_current_user()
    item = CartItem.query.filter_by(id=item_id, cart_id=cart.id).first_or_404()
    db.session.delete(item)
    db.session.commit()
    return _json_ok(_serialize_cart(cart))


@shop_api_bp.delete('/cart')
def clear_cart():
    cart = _get_cart_for_current_user()
    for item in list(cart.items):
        db.session.delete(item)
    db.session.commit()
    return _json_ok(_serialize_cart(cart))


# ===================== ORDERS =====================

def _get_orders_query_for_current_user():
    web_customer = _get_web_customer_from_jwt()
    if web_customer:
        conditions = [OnlineOrder.web_customer_id == web_customer.id]
        if web_customer.customer_id is not None:
            conditions.append(OnlineOrder.customer_id == web_customer.customer_id)
        session_ids = set()
        cs = _get_or_create_customer_session_for_web_customer(web_customer)
        session_ids.add(cs.id)
        if web_customer.email:
            by_email = CustomerSession.query.filter_by(email=web_customer.email).with_entities(CustomerSession.id).all()
            session_ids.update(r.id for r in by_email)
        if web_customer.customer_id is not None:
            by_cid = CustomerSession.query.filter_by(customer_id=web_customer.customer_id).with_entities(CustomerSession.id).all()
            session_ids.update(r.id for r in by_cid)
        if session_ids:
            conditions.append(OnlineOrder.session_id.in_(list(session_ids)))
        return OnlineOrder.query.filter(db.or_(*conditions))
    cs = _get_or_create_shop_customer_session()
    return OnlineOrder.query.filter(OnlineOrder.session_id == cs.id)


def _serialize_order(order):
    return {
        'id': order.id,
        'code': order.code,
        'tracking_token': order.tracking_token,
        'status': order.status,
        'customerId': order.customer_id,
        'webCustomerId': order.web_customer_id,
        'customerName': order.customer_name,
        'customerPhone': order.customer_phone,
        'customerEmail': order.customer_email,
        'shippingAddress': order.shipping_address,
        'paymentMethod': order.payment_method or 'COD',
        'subtotal_amount': float(order.subtotal or 0),
        'discount_amount': float(order.discount_amount or 0),
        'shipping_fee': float(order.shipping_fee or 0),
        'vat_amount': float(order.vat_amount or 0),
        'total_amount': float(order.total_amount or 0),
        'promo_code': order.promotion.code if order.promotion else None,
        'promo_desc': order.promotion.description if order.promotion else None,
        'note': order.note,
        'createdAt': order.created_at.isoformat() if order.created_at else None,
        'updatedAt': order.updated_at.isoformat() if order.updated_at else None,
        'erp_status': order.erp_status,
        'erp_note': order.erp_note,
        'return_status': order.return_status,
        'return_requested_at': order.return_requested_at.isoformat() if order.return_requested_at else None,
        'return_processed_at': order.return_processed_at.isoformat() if order.return_processed_at else None,
        'return_note': order.return_note,
        'returned_at': order.returned_at.isoformat() if order.returned_at else None,
        'delivered_at': order.delivered_at.isoformat() if getattr(order, 'delivered_at', None) else None,
        'completed_at': order.completed_at.isoformat() if getattr(order, 'completed_at', None) else None,
        'tracking_number': order.tracking_number,
        'tracking_carrier': order.tracking_carrier,
        'logs': [l.to_dict() for l in getattr(order, 'logs', []).order_by('created_at').all()] if hasattr(order, 'logs') else [],
        'items': [
            {
                'id': it.id,
                'product_id': it.product_id,
                'name': it.product_name_snapshot,
                'sku': it.product.code if it.product else '',
                'unit_price': float(it.unit_price or 0),
                'quantity': float(it.quantity or 0),
                'amount': float(it.amount or 0),
            }
            for it in order.items
        ],
    }


@shop_api_bp.get('/orders')
def list_orders():
    page = request.args.get('page', 1, type=int)
    per_page = min(request.args.get('per_page', 10, type=int), 50)
    q = _get_orders_query_for_current_user()
    if q is None:
        return _json_ok({'items': [], 'total': 0, 'page': page, 'per_page': per_page, 'pages': 0})
    status = request.args.get('status', '')
    if status:
        q = q.filter(OnlineOrder.status == status)
    pagination = q.order_by(OnlineOrder.created_at.desc()).paginate(
        page=page, per_page=per_page, error_out=False
    )
    items = list(pagination.items)
    dirty = []
    for o in items:
        if o.stock_out_id:
            o.update_erp_status('auto')
            dirty.append(o)
    if dirty:
        db.session.commit()
    if not items:
        current_app.logger.info(
            'Shop orders list empty: web_customer=%s, session=%s, total=%s',
            _get_web_customer_from_jwt().id if _get_web_customer_from_jwt() else None,
            request.cookies.get('shop_session'),
            pagination.total,
        )
    return _json_ok({
        'items': [_serialize_order(o) for o in items],
        'total': pagination.total,
        'page': page,
        'per_page': per_page,
        'pages': pagination.pages,
    })


@shop_api_bp.get('/orders/<code>')
def order_detail(code):
    order = _get_orders_query_for_current_user().filter_by(code=code).first()
    if not order:
        return _json_err('Không tìm thấy đơn hàng.', 404)
    if order.stock_out_id:
        order.update_erp_status('auto')
        db.session.commit()
    return _json_ok(_serialize_order(order))


@shop_api_bp.post('/orders')
def create_order():
    cart = _get_cart_for_current_user()
    items = cart.items.order_by(CartItem.id.asc()).all()
    if not items:
        return _json_err('Giỏ hàng đang trống.', 400)
    payload = request.get_json(silent=True) or {}
    customer_name = (payload.get('customerName') or 'Khách online').strip()
    customer_phone = (payload.get('customerPhone') or '').strip()
    customer_email = (payload.get('customerEmail') or '').strip().lower()
    shipping_address = (payload.get('shippingAddress') or '').strip()
    payment_method = (payload.get('paymentMethod') or 'COD').strip()
    payment_status = (payload.get('paymentStatus') or 'Unpaid').strip()
    note = (payload.get('note') or '').strip()
    promo_code = (payload.get('promotionCode') or '').strip().upper()
    shipping_fee = _num(payload.get('shippingFee'), 0)
    discount_amount = 0.0
    promotion = None
    if promo_code:
        promotion = Promotion.query.filter(
            db.func.lower(Promotion.code) == promo_code.lower(),
            Promotion.is_active.is_(True),
        ).first()
        if not promotion:
            return _json_err('Mã khuyến mãi không hợp lệ.', 400)
    subtotal = sum(float(i.quantity or 0) * float(i.unit_price or 0) for i in items)
    if promotion:
        discount_amount = promotion.calculate_discount(subtotal)
    vat_amount = 0
    total = subtotal - discount_amount + shipping_fee + vat_amount
    web_customer = _get_web_customer_from_jwt()
    customer_id = None
    web_customer_id = None
    if web_customer:
        customer = _ensure_erp_customer_for_web(web_customer)
        customer_id = customer.id
        web_customer_id = web_customer.id
    order_code = generate_online_order_code()
    order = OnlineOrder(
        code=order_code,
        tracking_token=generate_tracking_token(),
        session_id=cart.session_id,
        customer_id=customer_id,
        web_customer_id=web_customer_id,
        promotion_id=promotion.id if promotion else None,
        customer_name=customer_name,
        customer_phone=customer_phone,
        customer_email=customer_email,
        shipping_address=shipping_address,
        payment_method=payment_method,
        subtotal=subtotal,
        discount_amount=discount_amount,
        shipping_fee=shipping_fee,
        vat_amount=vat_amount,
        total_amount=total,
        status='new',
        sync_status='pending',
        note=note,
    )
    db.session.add(order)
    db.session.flush()
    for item in items:
        amount = float(item.quantity or 0) * float(item.unit_price or 0)
        db.session.add(OnlineOrderItem(
            online_order_id=order.id,
            listing_id=item.listing_id,
            product_id=item.product_id,
            product_name_snapshot=(item.listing.display_name() if item.listing and hasattr(item.listing, 'display_name') else (item.product.name if item.product else None)),
            quantity=item.quantity,
            unit_price=item.unit_price,
            amount=amount,
        ))
    cart.status = 'ordered'
    db.session.commit()
    _notify_admins(
        title=f'Don hang moi {order.code}',
        message=f'Khach hang {customer_name} dat hang moi tu website. Tong tien: {total:,.0f}d.',
        noti_type='success',
        module='ecommerce',
        reference_id=order.id,
        reference_type='online_order',
    )
    try:
        _broadcast('new_order', {
            'order_id': order.id,
            'code': order.code,
            'customer_name': customer_name,
            'total_amount': float(total),
            'status': order.status,
            'created_at': order.created_at.isoformat() if order.created_at else None,
        })
    except Exception:
        pass
    try:
        from app.routes.erp_events import broadcast_to_erp
        broadcast_to_erp('new_order', {
            'order_id': order.id,
            'code': order.code,
            'customer_name': customer_name,
            'total_amount': float(total),
            'status': order.status,
            'created_at': order.created_at.isoformat() if order.created_at else None,
        })
    except Exception:
        pass
    return _json_ok({'order': _serialize_order(order)}, message='Dat hang thanh cong.')


@shop_api_bp.post('/orders/<int:order_id>/reorder')
def reorder_order(order_id):
    web_customer = _get_web_customer_from_jwt()
    if not web_customer:
        return _json_err('Vui lòng đăng nhập để mua lại.', 401)
    q = _get_orders_query_for_current_user()
    order = q.filter_by(id=order_id).first_or_404()
    cart = _get_cart_for_current_user()
    added = 0
    for item in order.items:
        listing = ProductListing.query.filter_by(id=item.listing_id, is_published=True).first()
        if not listing:
            continue
        existing = CartItem.query.filter_by(cart_id=cart.id, listing_id=listing.id).first()
        if existing:
            existing.quantity = float(existing.quantity or 0) + float(item.quantity or 1)
        else:
            db.session.add(CartItem(
                cart_id=cart.id,
                listing_id=listing.id,
                product_id=listing.product_id,
                quantity=item.quantity,
                unit_price=listing.display_retail_price(),
            ))
        added += 1
    db.session.commit()
    return _json_ok({'added': added, 'cart': _serialize_cart(cart)})


@shop_api_bp.post('/orders/<int:order_id>/cancel')
def cancel_order(order_id):
    web_customer = _get_web_customer_from_jwt()
    if not web_customer:
        return _json_err('Vui lòng đăng nhập.', 401)
    q = _get_orders_query_for_current_user()
    order = q.filter_by(id=order_id).first()
    if not order:
        return _json_err('Không tìm thấy đơn hàng.', 404)
    if order.status not in {'new', 'pending', 'confirmed'}:
        return _json_err('Chỉ có thể hủy đơn hàng ở trạng thái Mới, Chờ thanh toán hoặc Đã xác nhận.', 400)
    if order.stock_out_id or order.erp_status:
        return _json_err('Đơn hàng đã được đồng bộ với phiếu xuất kho, không thể hủy.', 400)
    order.status = 'cancelled'
    if order.stock_out_id:
        from app.domains.inventory.services.inventory_service import InventoryService
        stock_out = order.stock_out
        if stock_out and stock_out.status != 'cancelled':
            if stock_out.status == 'confirmed':
                for item in stock_out.items.all():
                    if item.product_id and item.quantity:
                        try:
                            InventoryService.stock_in(
                                item.product_id,
                                stock_out.warehouse_id,
                                float(item.quantity),
                                float(item.cost_price or 0),
                                reference_code=f'Huy don {order.code}',
                                note=f'Hoan tra hang tu don hang online {order.code}',
                            )
                        except Exception as e:
                            db.session.rollback()
                            return _json_err(f'Loi khi hoan tra ton kho cho san pham #{item.product_id}: {str(e)}', 500)
            stock_out.status = 'cancelled'
            order.erp_status = 'Da huy'
            order.erp_note = f'Don hang bi huy boi khach hang. Phieu xuat {stock_out.code} da duoc huy va ton kho da duoc hoan tra.'
    db.session.commit()
    add_order_log(order, 'cancelled', status_from='new', status_to='cancelled', message='Đơn hàng bị hủy bởi khách hàng.', created_by=web_customer.id, created_by_name=web_customer.name)
    _notify_admins(
        title=f'Khach hang huy don {order.code}',
        message=f'Don hang {order.code} cua khach {order.customer_name} da bi huy boi khach hang.',
        noti_type='warning',
        module='ecommerce',
        reference_id=order.id,
        reference_type='online_order',
    )
    try:
        _broadcast('order_cancelled', {
            'order_id': order.id,
            'code': order.code,
            'customer_name': order.customer_name,
            'status': order.status,
            'erp_status': order.erp_status,
            'created_at': order.created_at.isoformat() if order.created_at else None,
        })
    except Exception:
        pass
    try:
        from app.routes.erp_events import broadcast_to_erp
        broadcast_to_erp('order_cancelled', {
            'order_id': order.id,
            'code': order.code,
            'customer_name': order.customer_name,
            'status': order.status,
            'erp_status': order.erp_status,
            'created_at': order.created_at.isoformat() if order.created_at else None,
        })
    except Exception:
        pass
    return _json_ok({'order': _serialize_order(order)})


@shop_api_bp.post('/orders/<int:order_id>/request-return')
def request_return(order_id):
    web_customer = _get_web_customer_from_jwt()
    if not web_customer:
        return _json_err('Vui lòng đăng nhập.', 401)
    q = _get_orders_query_for_current_user()
    order = q.filter_by(id=order_id).first()
    if not order:
        return _json_err('Không tìm thấy đơn hàng.', 404)
    if order.return_status == 'requested':
        return _json_err('Bạn đã gửi yêu cầu trả hàng cho đơn này rồi.', 400)
    if order.return_status in ('approved', 'completed'):
        return _json_err('Đơn hàng đang trong quá trình xử lý trả hàng.', 400)
    if order.status == 'cancelled':
        return _json_err('Đơn hàng đã bị hủy, không thể yêu cầu trả hàng.', 400)
    order.return_status = 'requested'
    order.return_requested_at = datetime.utcnow()
    order.return_note = None
    db.session.commit()
    try:
        _notify_admins(
            title=f'Khách hàng yêu cầu trả hàng {order.code}',
            message=f'Khách {order.customer_name} vừa gửi yêu cầu trả hàng cho đơn {order.code}.',
            noti_type='warning',
            module='ecommerce',
            reference_id=order.id,
            reference_type='online_order',
        )
    except Exception:
        pass
    return _json_ok({'order': _serialize_order(order)})


@shop_api_bp.post('/orders/<int:order_id>/cancel-return')
def cancel_return_request(order_id):
    web_customer = _get_web_customer_from_jwt()
    if not web_customer:
        return _json_err('Vui lòng đăng nhập.', 401)
    q = _get_orders_query_for_current_user()
    order = q.filter_by(id=order_id).first()
    if not order:
        return _json_err('Không tìm thấy đơn hàng.', 404)
    if order.return_status != 'requested':
        return _json_err('Đơn hàng không có yêu cầu trả hàng đang chờ xử lý.', 400)
    order.return_status = 'none'
    order.return_requested_at = None
    order.return_note = None
    db.session.commit()
    return _json_ok({'order': _serialize_order(order)})


@shop_api_bp.delete('/orders/<int:order_id>')
def delete_order(order_id):
    web_customer = _get_web_customer_from_jwt()
    if not web_customer:
        return _json_err('Vui lòng đăng nhập.', 401)
    q = _get_orders_query_for_current_user()
    order = q.filter_by(id=order_id).first()
    if not order:
        return _json_err('Không tìm thấy đơn hàng.', 404)
    if order.status != 'new':
        return _json_err('Chỉ có thể xóa đơn hàng ở trạng thái Mới.', 400)
    if order.stock_out_id or order.erp_status:
        return _json_err('Đơn hàng đã được đồng bộ với phiếu xuất kho, không thể xóa.', 400)
    order_code = order.code
    OnlineOrderItem.query.filter_by(online_order_id=order.id).delete(synchronize_session=False)
    db.session.delete(order)
    db.session.commit()
    current_app.logger.info(f'Shop customer {web_customer.id} deleted online order {order_code}')
    return _json_ok(message='Da xoa don hang thanh cong.')


# ===================== CUSTOMER =====================

@shop_api_bp.get('/customer/profile')
@jwt_required()
def get_profile():
    web_customer = _get_web_customer_from_jwt()
    if not web_customer:
        return _json_err('Unauthorized', 401)
    customer = web_customer.customer
    return _json_ok({
        'id': web_customer.id,
        'name': web_customer.name,
        'email': web_customer.email,
        'phone': web_customer.phone,
        'customer_id': web_customer.customer_id,
        'customer': customer.to_dict() if customer else None,
    })


@shop_api_bp.put('/customer/profile')
@jwt_required()
def update_profile():
    web_customer = _get_web_customer_from_jwt()
    if not web_customer:
        return _json_err('Unauthorized', 401)
    payload = request.get_json(silent=True) or {}
    web_customer.name = (payload.get('name') or web_customer.name).strip()
    web_customer.phone = (payload.get('phone') or web_customer.phone).strip()
    customer = _ensure_erp_customer_for_web(web_customer)
    customer.name = web_customer.name
    customer.phone = web_customer.phone
    if payload.get('email'):
        web_customer.email = payload['email'].strip().lower()
        customer = _ensure_erp_customer_for_web(web_customer)
        customer.email = web_customer.email
    db.session.commit()
    return _json_ok({
        'id': web_customer.id,
        'name': web_customer.name,
        'email': web_customer.email,
        'phone': web_customer.phone,
        'customer_id': web_customer.customer_id,
    }, message='Đã cập nhật thông tin.')


@shop_api_bp.put('/customer/password')
@jwt_required()
def change_password():
    web_customer = _get_web_customer_from_jwt()
    if not web_customer:
        return _json_err('Unauthorized', 401)
    payload = request.get_json(silent=True) or {}
    current_password = payload.get('current_password') or ''
    new_password = payload.get('new_password') or ''
    confirm = payload.get('confirm_password') or ''
    if not web_customer.check_password(current_password):
        return _json_err('Mật khẩu hiện tại không đúng.', 400)
    if new_password != confirm:
        return _json_err('Mật khẩu xác nhận không khớp.', 400)
    if len(new_password) < 8:
        return _json_err('Mật khẩu mới tối thiểu 8 ký tự.', 400)
    web_customer.set_password(new_password, store_plain=True)
    db.session.commit()
    return _json_ok(message='Doi mat khau thanh cong.')


# ===================== PROMOTIONS =====================

@shop_api_bp.get('/promotions')
def list_promotions():
    now = datetime.utcnow()
    promos = Promotion.query.filter(
        Promotion.is_active.is_(True),
        db.or_(Promotion.starts_at.is_(None), Promotion.starts_at <= now),
        db.or_(Promotion.ends_at.is_(None), Promotion.ends_at >= now),
    ).all()
    return _json_ok({
        'promotions': [
            {
                'id': p.id,
                'code': p.code,
                'name': p.name,
                'description': p.description,
                'discount_type': p.discount_type,
                'discount_value': float(p.discount_value or 0),
                'min_order_amount': float(p.min_order_amount or 0),
            }
            for p in promos
        ]
    })


@shop_api_bp.post('/promotions/validate')
def validate_promotion():
    payload = request.get_json(silent=True) or {}
    code = (payload.get('code') or '').strip().upper()
    amount = _num(payload.get('amount'), 0)
    if not code:
        return _json_err('Thiếu mã khuyến mãi.', 400)
    promo = Promotion.query.filter(
        db.func.lower(Promotion.code) == code.lower(),
        Promotion.is_active.is_(True),
    ).first()
    if not promo:
        return _json_err('Mã khuyến mãi không hợp lệ.', 404)
    now = datetime.utcnow()
    if promo.starts_at and promo.starts_at > now:
        return _json_err('Mã khuyến mãi chưa có hiệu lực.', 400)
    if promo.ends_at and promo.ends_at < now:
        return _json_err('Mã khuyến mãi đã hết hạn.', 400)
    if amount < float(promo.min_order_amount or 0):
        return _json_err(f'Đơn tối thiểu {float(promo.min_order_amount or 0):,.0f}đ.', 400)
    discount = promo.calculate_discount(amount)
    return _json_ok({
        'promotion': {
            'id': promo.id,
            'code': promo.code,
            'name': promo.name,
            'discount_type': promo.discount_type,
            'discount_value': float(promo.discount_value or 0),
        },
        'discount_amount': discount,
    })


# ===================== BACKWARD COMPATIBLE ENDPOINTS =====================

@shop_api_bp.post('/checkout-json')
def checkout_json_legacy():
    payload = request.get_json(silent=True) or {}
    cart = _active_cart()
    items = payload.get('items') or []
    customer_name = payload.get('customerName') or 'Khách online'
    shipping_address = payload.get('shippingAddress') or ''
    payment_method = payload.get('paymentMethod') or 'VietQR'
    payment_status = payload.get('paymentStatus') or ('Paid' if payment_method == 'VietQR' else 'Unpaid')
    note = payload.get('note') or ''
    subtotal = sum(_num(it.get('unitPrice')) * _num(it.get('quantity')) for it in items)
    tax_amount = 0
    total = subtotal + tax_amount
    order_code = generate_online_order_code()
    customer_id = None
    web_customer_id = None
    if current_user.is_authenticated and isinstance(current_user._get_current_object(), WebCustomer):
        web_customer = _get_web_customer_from_jwt()
        if web_customer:
            customer = _ensure_erp_customer_for_web(web_customer)
            customer_id = customer.id
            web_customer_id = web_customer.id
    order = OnlineOrder(
        code=order_code,
        tracking_token=generate_tracking_token(),
        session_id=cart.session_id,
        customer_id=customer_id,
        web_customer_id=web_customer_id,
        customer_name=customer_name,
        shipping_address=shipping_address,
        subtotal=subtotal,
        discount_amount=0,
        shipping_fee=0,
        vat_amount=tax_amount,
        total_amount=total,
        status='new',
        sync_status='pending',
        note=note,
    )
    db.session.add(order)
    db.session.flush()
    for it in items:
        product_id = it.get('productId')
        listing_id = None
        listing = None
        if product_id is not None:
            listing = ProductListing.query.filter_by(product_id=product_id).first()
        if listing is not None:
            listing_id = listing.id
            product_snapshot_name = listing.display_name()
            unit_price = _num(it.get('unitPrice'), 0)
            qty = _num(it.get('quantity'), 1)
            amount = unit_price * qty
            db.session.add(OnlineOrderItem(
                online_order_id=order.id,
                listing_id=listing_id,
                product_id=listing.product_id,
                product_name_snapshot=product_snapshot_name,
                quantity=qty,
                unit_price=unit_price,
                amount=amount,
            ))
    cart.status = 'ordered'
    db.session.commit()
    return jsonify({'ok': True, 'code': order.code})
