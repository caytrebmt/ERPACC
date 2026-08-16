from datetime import datetime
import json
import queue
import threading
import time

from flask import Blueprint, flash, jsonify, redirect, render_template, request, Response, session, url_for
from flask_login import current_user, login_required

from app.database import db
from app.domains.ecommerce.models import OnlineOrder, OnlineOrderItem, ProductListing, WebCustomer
from app.domains.inventory.models import StockIn, StockInItem
from app.domains.master.models import Category, Product, Warehouse
from app.domains.platform.models import NotificationInstance
from app.domains.platform.services.company_service import get_company_value
from app.shared.authz import require_permission
from app.shared.filters import EcommerceOrderFilters, ProductFilters, ShopCustomerFilters
from app.domains.ecommerce.services.ecommerce_sync_service import (
    ensure_listing_for_all_active_products,
    listing_query,
    publish_product_listing,
    sync_inventory_to_listings,
    sync_online_order_to_stock_out,
)

ecommerce_bp = Blueprint('ecommerce', __name__, url_prefix='/ecommerce')

_clients = []
_client_lock = threading.Lock()


def _notify_admins(title, message, noti_type='info', module='ecommerce', reference_id=None, reference_type=None):
    try:
        from app.models.system import User
        admins = User.query.filter_by(role='admin', is_active=True).all()
        if not admins:
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


def _generate_stock_in_code():
    prefix_cfg = (get_company_value('invoice_prefix_in', 'PN') or 'PN').upper()
    today = datetime.utcnow().strftime('%y%m%d')
    prefix = f'{prefix_cfg}-{today}-'
    last = StockIn.query.filter(StockIn.code.like(f'{prefix}%')).order_by(
        StockIn.code.desc()).first()
    if last:
        num = int(last.code.split('-')[-1]) + 1
    else:
        num = 1
    return f'{prefix}{num:03d}'


def _listings_redirect():
    return redirect(url_for(
        'ecommerce.listings',
        search=session.get('listings_search', ''),
        published=session.get('listings_published', ''),
        category_id=session.get('listings_category_id') or None,
        page=session.get('listings_page', 1),
    ))


def _broadcast(event_type, payload):
    msg = json.dumps({'type': event_type, 'data': payload, 'ts': time.time()}, ensure_ascii=False)
    dead = []
    with _client_lock:
        for q in _clients:
            try:
                q.put_nowait(msg)
            except Exception:
                dead.append(q)
        for q in dead:
            try:
                _clients.remove(q)
            except ValueError:
                pass


@ecommerce_bp.route('/')
@login_required
@require_permission('ecommerce', 'view')
def dashboard():
    return ProductFilters.redirect('ecommerce.listings', search='', published='', category_id=None, page=1)


@ecommerce_bp.route('/listings')
@login_required
@require_permission('ecommerce', 'view')
def listings():
    search = request.args.get('search', '')
    published = request.args.get('published', '')
    category_id = request.args.get('category_id', type=int)
    page = request.args.get('page', 1, type=int)

    rows = listing_query(search, published, category_id).order_by(Product.code.asc()).paginate(
        page=page, per_page=30, error_out=False
    )

    session['listings_search'] = search
    session['listings_published'] = published
    session['listings_category_id'] = category_id
    session['listings_page'] = page

    try:
        categories = Category.query.filter_by(is_active=True).order_by(Category.name).all()
    except Exception:
        categories = []

    return render_template(
        'ecommerce/listings.html',
        listings=rows,
        search=search,
        published=published,
        category_id=category_id,
        categories=categories,
    )


@ecommerce_bp.post('/listings/ensure')
@login_required
@require_permission('ecommerce', 'create')
def ensure_listings():
    created = ensure_listing_for_all_active_products()
    flash(f'Đã tạo gợi ý listing web cho {created} sản phẩm.', 'success')
    return _listings_redirect()


@ecommerce_bp.post('/listings/publish/<int:product_id>')
@login_required
@require_permission('ecommerce', 'edit')
def publish_listing(product_id):
    listing = publish_product_listing(product_id)
    db.session.commit()
    flash(f'Đã bật bán web: {listing.display_name()}', 'success')
    return _listings_redirect()


@ecommerce_bp.post('/listings/<int:id>/toggle')
@login_required
@require_permission('ecommerce', 'edit')
def toggle_listing(id):
    listing = ProductListing.query.get_or_404(id)
    listing.is_published = not listing.is_published
    listing.updated_at = datetime.utcnow()
    db.session.commit()
    flash('Đã cập nhật trạng thái hiển thị web.', 'success')
    return _listings_redirect()


@ecommerce_bp.post('/sync-inventory')
@login_required
@require_permission('ecommerce', 'edit')
def sync_inventory():
    count = sync_inventory_to_listings()
    flash(f'Đã đồng bộ tồn kho web cho {count} listing.', 'success')
    return _listings_redirect()


@ecommerce_bp.route('/orders')
@ecommerce_bp.route('/orders/board')
@login_required
@require_permission('ecommerce', 'view')
def orders():
    view = request.args.get('view', 'table')
    search = request.args.get('search', '')
    sync_status = request.args.get('sync_status', '')
    page = request.args.get('page', 1, type=int)

    q = OnlineOrder.query
    if search:
        pattern = f'%{search}%'
        q = q.filter(db.or_(
            OnlineOrder.code.ilike(pattern),
            OnlineOrder.customer_name.ilike(pattern),
            OnlineOrder.customer_phone.ilike(pattern),
        ))
    if sync_status:
        q = q.filter(OnlineOrder.sync_status == sync_status)

    warehouses = Warehouse.query.filter_by(is_active=True).order_by(Warehouse.name).all()
    EcommerceOrderFilters.save(search=search, sync_status=sync_status, page=page)

    if view == 'board':
        all_orders = q.order_by(OnlineOrder.created_at.desc()).all()
        board = {
            'new': [],
            'pending': [],
            'confirmed': [],
            'shipped': [],
            'returned': [],
            'cancelled': [],
        }
        for o in all_orders:
            if o.return_status == 'completed' or o.status == 'returned':
                board['returned'].append(o)
            elif o.stock_out_id and o.erp_status == 'Đã xuất kho':
                board['shipped'].append(o)
            elif o.status in board:
                board[o.status].append(o)
            else:
                board['new'].append(o)
        return render_template(
            'ecommerce/orders_board.html',
            board=board,
            warehouses=warehouses,
            search=search,
            sync_status=sync_status,
        )

    rows = q.order_by(OnlineOrder.created_at.desc()).paginate(
        page=page, per_page=30, error_out=False
    )
    return render_template(
        'ecommerce/orders.html',
        orders=rows,
        warehouses=warehouses,
        search=search,
        sync_status=sync_status,
    )


@ecommerce_bp.route('/orders/<int:id>')
@login_required
@require_permission('ecommerce', 'view')
def order_detail(id):
    order = OnlineOrder.query.get_or_404(id)
    items = order.items.order_by(OnlineOrderItem.created_at.asc()).all()
    warehouses = Warehouse.query.filter_by(is_active=True).order_by(Warehouse.name).all()
    return render_template(
        'ecommerce/orders_detail.html',
        order=order,
        items=items,
        warehouses=warehouses,
    )


@ecommerce_bp.post('/orders/<int:id>/delete')
@login_required
@require_permission('ecommerce', 'delete')
def delete_order(id):
    order = OnlineOrder.query.get_or_404(id)
    order_code = order.code
    OnlineOrderItem.query.filter_by(online_order_id=order.id).delete(synchronize_session=False)
    db.session.delete(order)
    db.session.commit()
    flash(f'Đã xóa đơn hàng {order_code}.', 'success')
    return EcommerceOrderFilters.redirect('ecommerce.orders', search='', sync_status='', page=1)


@ecommerce_bp.post('/orders/<int:id>/approve-return')
@login_required
@require_permission('ecommerce', 'edit')
def approve_return(id):
    order = OnlineOrder.query.get_or_404(id)
    if order.return_status != 'requested':
        flash('Đơn hàng không có yêu cầu trả hàng đang chờ xử lý.', 'warning')
        return redirect(url_for('ecommerce.order_detail', id=id))
    if not order.stock_out or order.stock_out.status != 'confirmed':
        flash('Đơn hàng chưa được xuất kho (ERP), không thể xử lý trả hàng.', 'warning')
        return redirect(url_for('ecommerce.order_detail', id=id))
    warehouse_id = request.form.get('warehouse_id', type=int) or order.stock_out.warehouse_id
    note = request.form.get('return_note', '').strip()
    try:
        stock_in = StockIn(
            code=_generate_stock_in_code(),
            date=datetime.utcnow().date(),
            supplier_id=None,
            warehouse_id=warehouse_id,
            unit_id=order.stock_out.unit_id,
            invoice_no=f'RETURN-{order.code}',
            invoice_date=datetime.utcnow().date(),
            discount_amount=0,
            note=f'Trả hàng từ đơn online {order.code}. {note or ""}'.strip(),
            vat_manual=False,
            vat_manual_val=0,
            status='draft',
            created_by=current_user.id,
        )
        db.session.add(stock_in)
        db.session.flush()
        for item in order.stock_out.items.all():
            if item.product_id and item.quantity:
                si_item = StockInItem(
                    stock_in_id=stock_in.id,
                    product_id=item.product_id,
                    quantity=item.quantity,
                    unit_id=item.unit_id,
                    conversion_factor=item.conversion_factor or 1,
                    unit_price=item.unit_price or 0,
                    vat_rate=0,
                )
                si_item.calculate()
                db.session.add(si_item)
        db.session.flush()
        stock_in.calculate_totals()
        db.session.flush()
        from app.domains.inventory.services.inventory_service import InventoryService
        for line in stock_in.items.all():
            qty_base = float(line.quantity or 0) * float(line.conversion_factor or 1)
            InventoryService.stock_in(
                line.product_id,
                stock_in.warehouse_id,
                qty_base,
                float(line.unit_price or 0),
                reference_code=f'Tra hang {order.code}',
                note=f'Nhập kho trả hàng từ đơn online {order.code}',
                user_id=current_user.id,
            )
        stock_in.status = 'confirmed'
        stock_in.confirmed_by = current_user.id
        stock_in.confirmed_at = datetime.utcnow()
        if order.stock_out:
            order.stock_out.note = ((order.stock_out.note or '') + f'\n[TRẢ HÀNG] Đơn {order.code} đã trả hàng, tạo PN {stock_in.code}.').strip()
        order.return_status = 'completed'
        order.return_processed_at = datetime.utcnow()
        order.return_note = note
        order.stock_in_id = stock_in.id
        order.returned_at = datetime.utcnow()
        order.status = 'returned'
        db.session.commit()
        flash(f'Đã xử lý trả hàng cho đơn {order.code}. Phiếu nhập kho: {stock_in.code}', 'success')
    except Exception as exc:
        db.session.rollback()
        flash(f'Lỗi xử lý trả hàng: {exc}', 'danger')
    return redirect(url_for('ecommerce.order_detail', id=id))


@ecommerce_bp.post('/orders/<int:id>/reject-return')
@login_required
@require_permission('ecommerce', 'edit')
def reject_return(id):
    order = OnlineOrder.query.get_or_404(id)
    if order.return_status != 'requested':
        flash('Đơn hàng không có yêu cầu trả hàng đang chờ xử lý.', 'warning')
        return redirect(url_for('ecommerce.order_detail', id=id))
    note = request.form.get('return_note', '').strip()
    order.return_status = 'rejected'
    order.return_processed_at = datetime.utcnow()
    order.return_note = note
    db.session.commit()
    flash(f'Đã từ chối yêu cầu trả hàng cho đơn {order.code}.', 'success')
    return redirect(url_for('ecommerce.order_detail', id=id))


@ecommerce_bp.post('/orders/<int:id>/sync')
@login_required
@require_permission('ecommerce', 'edit')
def sync_order(id):
    warehouse_id = request.form.get('warehouse_id', type=int)
    confirm_inventory = request.form.get('confirm_inventory') == '1'
    try:
        stock_out = sync_online_order_to_stock_out(
            id,
            warehouse_id=warehouse_id,
            user_id=current_user.id,
            confirm_inventory=confirm_inventory,
        )
        flash(f'Đã sync đơn online sang phiếu xuất {stock_out.code}.', 'success')
    except Exception as exc:
        order = OnlineOrder.query.get(id)
        if order:
            order.sync_status = 'failed'
            order.sync_error = str(exc)
            db.session.commit()
        flash(str(exc), 'danger')
    return EcommerceOrderFilters.redirect('ecommerce.orders', search='', sync_status='', page=1)


# ===================== SHOP CUSTOMERS =====================

@ecommerce_bp.route('/shop-customers')
@login_required
@require_permission('ecommerce', 'view')
def shop_customers():
    search = (request.args.get('search', '') or '').strip()
    page = request.args.get('page', 1, type=int)
    q = WebCustomer.query
    if search:
        pattern = f'%{search}%'
        q = q.filter(db.or_(
            WebCustomer.email.ilike(pattern),
            WebCustomer.name.ilike(pattern),
            WebCustomer.phone.ilike(pattern),
        ))
    rows = q.order_by(WebCustomer.created_at.desc()).paginate(
        page=page, per_page=20, error_out=False
    )
    ShopCustomerFilters.save(search=search, page=page)
    return render_template(
        'ecommerce/shop_customers.html',
        customers=rows,
        search=search,
    )


@ecommerce_bp.route('/shop-customers/<int:id>')
@login_required
@require_permission('ecommerce', 'view')
def shop_customer_detail(id):
    customer = WebCustomer.query.get_or_404(id)
    page = request.args.get('page', 1, type=int)
    status = request.args.get('status', '')
    from_date = request.args.get('from_date', '')
    to_date = request.args.get('to_date', '')

    q = OnlineOrder.query.filter_by(web_customer_id=customer.id)
    if status:
        q = q.filter(OnlineOrder.status == status)
    if from_date:
        q = q.filter(OnlineOrder.created_at >= from_date)
    if to_date:
        q = q.filter(OnlineOrder.created_at <= to_date + ' 23:59:59')

    rows = q.order_by(OnlineOrder.created_at.desc()).paginate(
        page=page, per_page=20, error_out=False
    )
    return render_template(
        'ecommerce/shop_customer_detail.html',
        customer=customer,
        orders=rows,
        status=status,
        from_date=from_date,
        to_date=to_date,
    )


@ecommerce_bp.route('/shop-customers/create', methods=['GET', 'POST'])
@login_required
@require_permission('ecommerce', 'create')
def shop_customers_create():
    if request.method == 'POST':
        email = (request.form.get('email', '') or '').strip().lower()
        name = (request.form.get('name', '') or '').strip()
        phone = (request.form.get('phone', '') or '').strip()
        password = request.form.get('password', '')
        is_active = request.form.get('is_active') == 'on'
        if not email or not name or not password:
            flash('Email, ten va mat khau khong duoc de trong.', 'danger')
            return render_template('ecommerce/shop_customer_form.html', customer=None)
        if WebCustomer.query.filter_by(email=email).first():
            flash('Email nay da duoc dang ky.', 'danger')
            return render_template('ecommerce/shop_customer_form.html', customer=None)
        c = WebCustomer(email=email, name=name, phone=phone, is_active=is_active)
        c.set_password(password, store_plain=True)
        db.session.add(c)
        db.session.commit()
        flash('Tao tai khoan khach hang thanh cong.', 'success')
        return ShopCustomerFilters.redirect('ecommerce.shop_customers', search='', page=1)
    return render_template('ecommerce/shop_customer_form.html', customer=None)


@ecommerce_bp.route('/shop-customers/edit/<int:id>', methods=['GET', 'POST'])
@login_required
@require_permission('ecommerce', 'edit')
def shop_customers_edit(id):
    c = WebCustomer.query.get_or_404(id)
    if request.method == 'POST':
        c.name = (request.form.get('name', '') or c.name).strip()
        c.phone = (request.form.get('phone', '') or c.phone).strip()
        c.email = (request.form.get('email', '') or c.email).strip().lower()
        c.is_active = request.form.get('is_active') == 'on'
        password = request.form.get('password', '')
        if password:
            c.set_password(password, store_plain=True)
        db.session.commit()
        flash('Cap nhat khach hang thanh cong.', 'success')
        return ShopCustomerFilters.redirect('ecommerce.shop_customers', search='', page=1)
    return render_template('ecommerce/shop_customer_form.html', customer=c)


@ecommerce_bp.post('/shop-customers/delete/<int:id>')
@login_required
@require_permission('ecommerce', 'delete')
def shop_customers_delete(id):
    c = WebCustomer.query.get_or_404(id)
    db.session.delete(c)
    db.session.commit()
    flash('Da xoa tai khoan khach hang.', 'success')
    return ShopCustomerFilters.redirect('ecommerce.shop_customers', search='', page=1)


@ecommerce_bp.post('/shop-customers/toggle/<int:id>')
@login_required
@require_permission('ecommerce', 'edit')
def shop_customers_toggle(id):
    c = WebCustomer.query.get_or_404(id)
    c.is_active = not c.is_active
    db.session.commit()
    flash('Cap nhat trang thai thanh cong.', 'success')
    return ShopCustomerFilters.redirect('ecommerce.shop_customers', search='', page=1)


# ===================== NOTIFICATIONS =====================

@ecommerce_bp.route('/notifications')
@login_required
@require_permission('ecommerce', 'view')
def notifications():
    only_unread = request.args.get('unread') == '1'
    page = request.args.get('page', 1, type=int)
    q = NotificationInstance.query
    if only_unread:
        q = q.filter(NotificationInstance.is_read == False)
    rows = q.order_by(NotificationInstance.created_at.desc()).paginate(
        page=page, per_page=20, error_out=False
    )
    return render_template(
        'ecommerce/notifications.html',
        notifications=rows,
        only_unread=only_unread,
    )


@ecommerce_bp.post('/notifications/delete/<int:id>')
@login_required
@require_permission('ecommerce', 'delete')
def notifications_delete(id):
    n = NotificationInstance.query.get_or_404(id)
    if n.user_id != current_user.id and current_user.role != 'admin':
        flash('Khong co quyen xoa thong bao nay.', 'danger')
        return redirect(url_for('ecommerce.notifications'))
    db.session.delete(n)
    db.session.commit()
    flash('Da xoa thong bao.', 'success')
    return redirect(url_for('ecommerce.notifications'))


@ecommerce_bp.post('/notifications/mark-read/<int:id>')
@login_required
@require_permission('ecommerce', 'edit')
def notifications_mark_read(id):
    n = NotificationInstance.query.get_or_404(id)
    if n.user_id != current_user.id and current_user.role != 'admin':
        flash('Khong co quyen.', 'danger')
        return redirect(url_for('ecommerce.notifications'))
    n.is_read = True
    db.session.commit()
    flash('Da danh dau da doc.', 'success')
    return redirect(url_for('ecommerce.notifications'))


@ecommerce_bp.post('/notifications/mark-all-read')
@login_required
@require_permission('ecommerce', 'edit')
def notifications_mark_all_read():
    NotificationInstance.query.filter_by(user_id=current_user.id, is_read=False).update({'is_read': True})
    db.session.commit()
    flash('Da danh dau tat ca da doc.', 'success')
    return redirect(url_for('ecommerce.notifications'))


@ecommerce_bp.get('/notifications/unread-count')
@login_required
@require_permission('ecommerce', 'view')
def notifications_unread_count():
    count = NotificationInstance.query.filter_by(user_id=current_user.id, is_read=False).count()
    return jsonify({'ok': True, 'count': count})


@ecommerce_bp.get('/notifications/recent')
@login_required
@require_permission('ecommerce', 'view')
def notifications_recent():
    items = NotificationInstance.query.filter_by(user_id=current_user.id).order_by(NotificationInstance.created_at.desc()).limit(10).all()
    return jsonify({'ok': True, 'items': [n.to_dict() for n in items]})


@ecommerce_bp.post('/notifications/mark-read-json/<int:id>')
@login_required
@require_permission('ecommerce', 'edit')
def notifications_mark_read_json(id):
    n = NotificationInstance.query.get_or_404(id)
    if n.user_id != current_user.id and current_user.role != 'admin':
        return jsonify({'ok': False, 'message': 'Khong co quyen.'}), 403
    n.is_read = True
    db.session.commit()
    return jsonify({'ok': True, 'data': n.to_dict()})


@ecommerce_bp.get('/events')
@login_required
@require_permission('ecommerce', 'view')
def events():
    q = queue.Queue()
    with _client_lock:
        _clients.append(q)
    try:
        while True:
            msg = q.get()
            yield msg
    except GeneratorExit:
        with _client_lock:
            try:
                _clients.remove(q)
            except ValueError:
                pass


@ecommerce_bp.get('/events/last')
@login_required
@require_permission('ecommerce', 'view')
def events_last():
    return jsonify({'ok': True, 'ts': time.time()})
