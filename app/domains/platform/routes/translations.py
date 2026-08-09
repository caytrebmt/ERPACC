from flask import Blueprint, render_template, request, redirect, url_for, flash, jsonify
from flask_login import login_required, current_user
from app.database import db
from app.domains.platform.models import Menu
from app.shared.authz import require_permission
from app.shared.constants import Roles
from app.services.i18n_service import I18nService
import json
import os

translations_bp = Blueprint('translations', __name__, url_prefix='')


def _admin_only():
    if current_user.role != Roles.ADMIN:
        flash('Chỉ quản trị viên mới có quyền thực hiện!', 'danger')
        return False
    return True


@translations_bp.route('/translations')
@login_required
@require_permission('settings', 'view')
def list_translations():
    if not _admin_only():
        return redirect(url_for('dashboard.index'))
    lang = request.args.get('lang', 'vi')
    namespace = request.args.get('namespace', '')
    search = request.args.get('search', '').strip().lower()

    I18nService.load_translations()
    data = I18nService.get_all_translations(lang)

    flat_items = _flatten_dict(data)
    if namespace:
        prefix = namespace + '.'
        flat_items = {k: v for k, v in flat_items.items() if k.startswith(prefix)}
    if search:
        flat_items = {k: v for k, v in flat_items.items()
                      if search in k.lower() or search in str(v).lower()}

    namespaces = sorted({k.split('.')[0] for k in _flatten_dict(data).keys() if '.' in k})
    return render_template('settings/translations.html',
                           items=flat_items,
                           lang=lang,
                           namespace=namespace,
                           namespaces=namespaces,
                           search=search)


@translations_bp.route('/translations/save', methods=['POST'])
@login_required
@require_permission('settings', 'edit')
def save_translation():
    if not _admin_only():
        return redirect(url_for('dashboard.index'))

    key = request.form.get('key', '').strip()
    lang = request.form.get('lang', 'vi').strip()
    value = request.form.get('value', '')

    if not key or lang not in I18nService.SUPPORTED_LANGS:
        flash('Dữ liệu không hợp lệ.', 'danger')
        return redirect(url_for('translations.list_translations', lang=lang))

    file_path = I18nService.TRANSLATIONS_DIR / f"{lang}.json"
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception:
        data = {}

    keys = key.split('.')
    target = data
    for k in keys[:-1]:
        if k not in target or not isinstance(target[k], dict):
            target[k] = {}
        target = target[k]
    target[keys[-1]] = value

    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    I18nService._cache.clear()
    flash(f'Đã lưu bản dịch [{lang}] {key}.', 'success')
    return redirect(url_for('translations.list_translations', lang=lang))


@translations_bp.route('/translations/delete', methods=['POST'])
@login_required
@require_permission('settings', 'delete')
def delete_translation():
    if not _admin_only():
        return redirect(url_for('dashboard.index'))

    key = request.form.get('key', '').strip()
    lang = request.form.get('lang', 'vi').strip()

    if not key or lang not in I18nService.SUPPORTED_LANGS:
        flash('Dữ liệu không hợp lệ.', 'danger')
        return redirect(url_for('translations.list_translations', lang=lang))

    file_path = I18nService.TRANSLATIONS_DIR / f"{lang}.json"
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception:
        data = {}

    keys = key.split('.')
    target = data
    for k in keys[:-1]:
        if k not in target or not isinstance(target[k], dict):
            flash('Không tìm thấy key.', 'warning')
            return redirect(url_for('translations.list_translations', lang=lang))
        target = target[k]

    if keys[-1] in target:
        del target[keys[-1]]
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        I18nService._cache.clear()
        flash(f'Đã xóa bản dịch [{lang}] {key}.', 'success')
    else:
        flash('Không tìm thấy key.', 'warning')

    return redirect(url_for('translations.list_translations', lang=lang))


@translations_bp.route('/translations/scan-missing')
@login_required
@require_permission('settings', 'view')
def scan_missing():
    if not _admin_only():
        return redirect(url_for('dashboard.index'))

    I18nService.load_translations()
    vi_data = I18nService.get_all_translations('vi')
    en_data = I18nService.get_all_translations('en')

    vi_flat = _flatten_dict(vi_data)
    en_flat = _flatten_dict(en_data)

    used_keys = _collect_template_keys()
    missing_vi = {k: v for k, v in used_keys.items() if k not in vi_flat}
    missing_en = {k: v for k, v in used_keys.items() if k not in en_flat}

    return render_template('settings/translations_scan.html',
                           used_keys=sorted(used_keys.keys()),
                           missing_vi=sorted(missing_vi.keys()),
                           missing_en=sorted(missing_en.keys()),
                           total_used=len(used_keys),
                           total_vi=len(vi_flat),
                           total_en=len(en_flat))


def _flatten_dict(d, parent_key='', sep='.'):
    items = {}
    for k, v in d.items():
        new_key = f"{parent_key}{sep}{k}" if parent_key else k
        if isinstance(v, dict):
            items.update(_flatten_dict(v, new_key, sep=sep))
        else:
            items[new_key] = v
    return items


def _collect_template_keys():
    keys = set()
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
    for dirpath, _, filenames in os.walk(root):
        for fn in filenames:
            if fn.endswith('.html'):
                path = os.path.join(dirpath, fn)
                try:
                    with open(path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    import re
                    for m in re.finditer(r"t\((['\"])(.+?)\1\)", content):
                        keys.add(m.group(2))
                except Exception:
                    pass
    return keys
