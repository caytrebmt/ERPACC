from flask import Blueprint, render_template, request, redirect, url_for, flash
from flask_login import login_required, current_user
from app.database import db
from app.domains.platform.models import BusinessChange
from app.shared.authz import require_permission
from app.shared.constants import Roles

business_changes_bp = Blueprint('business_changes', __name__, url_prefix='')


def _admin_only():
    if current_user.role != Roles.ADMIN:
        flash('Chỉ quản trị viên mới có quyền thực hiện!', 'danger')
        return False
    return True


@business_changes_bp.route('/business-changes')
@login_required
@require_permission('settings', 'view')
def list_changes():
    if not _admin_only():
        return redirect(url_for('dashboard.index'))
    module = request.args.get('module', '')
    source = request.args.get('source', '')

    q = BusinessChange.query
    if module:
        q = q.filter(BusinessChange.module == module)
    if source:
        q = q.filter(BusinessChange.source == source)

    changes = q.order_by(BusinessChange.created_at.desc()).all()
    modules = db.session.query(BusinessChange.module).filter(
        BusinessChange.module.isnot(None)).distinct().all()
    modules = sorted([m[0] for m in modules if m[0]])
    return render_template('settings/business_changes.html',
                           changes=changes, module=module, source=source,
                           modules=modules)


@business_changes_bp.route('/business-changes/create', methods=['POST'])
@login_required
@require_permission('settings', 'create')
def create_change():
    if not _admin_only():
        return redirect(url_for('dashboard.index'))
    bc = BusinessChange(
        module=request.form.get('module', '').strip() or None,
        source=request.form.get('source', 'erp').strip(),
        change_type=request.form.get('change_type', 'update').strip(),
        title=request.form.get('title', '').strip(),
        description=request.form.get('description', '').strip() or None,
        is_active=request.form.get('is_active') == 'on',
    )
    db.session.add(bc)
    db.session.commit()
    flash('Đã thêm thông báo thay đổi nghiệp vụ.', 'success')
    return redirect(url_for('business_changes.list_changes'))


@business_changes_bp.route('/business-changes/toggle/<int:id>', methods=['POST'])
@login_required
@require_permission('settings', 'edit')
def toggle_change(id):
    if not _admin_only():
        return redirect(url_for('dashboard.index'))
    bc = BusinessChange.query.get_or_404(id)
    bc.is_active = not bc.is_active
    db.session.commit()
    return redirect(url_for('business_changes.list_changes'))


@business_changes_bp.route('/business-changes/delete/<int:id>', methods=['POST'])
@login_required
@require_permission('settings', 'delete')
def delete_change(id):
    if not _admin_only():
        return redirect(url_for('dashboard.index'))
    bc = BusinessChange.query.get_or_404(id)
    db.session.delete(bc)
    db.session.commit()
    flash('Đã xóa thông báo thay đổi.', 'success')
    return redirect(url_for('business_changes.list_changes'))
