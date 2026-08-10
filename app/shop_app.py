from __future__ import annotations

import os
from pathlib import Path

from flask import Flask, request, session, send_from_directory
from flask_babel import Babel
from flask_login import current_user, LoginManager
from flask_caching import Cache
from flask_wtf.csrf import CSRFProtect

from config.settings import config
from app.database import db
from app.domains.ecommerce.models import WebCustomer
from app.filters import register_filters
from app.domains.ecommerce.routes.shop import shop_bp


def create_shop_app(config_name: str | None = None) -> Flask:
    """Tạo Flask app riêng cho Shop để tách cookie/session ERP <-> Shop."""
    from datetime import timedelta

    if config_name is None:
        config_name = os.getenv('FLASK_ENV', 'development')

    resource_base = Path(__file__).resolve().parent
    template_dir = resource_base / 'templates'
    static_dir = resource_base / 'static'
    translations_dir = resource_base.parent / 'translations'

    app = Flask(
        __name__,
        template_folder=str(template_dir),
        static_folder=str(static_dir),
        root_path=str(resource_base),
    )
    app.config.from_object(config.get(config_name, config['default']))
    db.init_app(app)

    app.config['SESSION_COOKIE_NAME'] = 'shop_session'
    app.config['REMEMBER_COOKIE_NAME'] = 'shop_remember'

    shop_login_manager = LoginManager()
    shop_login_manager.login_view = 'shop.login'
    shop_login_manager.login_message = 'Vui lòng đăng nhập để tiếp tục.'
    shop_login_manager.login_message_category = 'warning'
    shop_login_manager.session_protection = app.config.get('SESSION_PROTECTION', 'strong')
    shop_login_manager.init_app(app)

    @shop_login_manager.user_loader
    def _load_shop_customer(user_id):
        if isinstance(user_id, str) and user_id.startswith('web:'):
            user_id = user_id[4:]
        return db.session.get(WebCustomer, int(user_id))

    cache = Cache()
    csrf = CSRFProtect()
    cache_config = {
        'CACHE_TYPE': app.config.get('CACHE_TYPE', 'SimpleCache'),
        'CACHE_DEFAULT_TIMEOUT': 300,
    }
    redis_url = app.config.get('REDIS_URL') or app.config.get('CACHE_REDIS_URL')
    if redis_url:
        cache_config['CACHE_TYPE'] = 'RedisCache'
        cache_config['CACHE_REDIS_URL'] = redis_url
    cache.init_app(app, config=cache_config)
    csrf.init_app(app)

    def _select_locale():
        return session.get('lang', 'vi')

    Babel(app, locale_selector=_select_locale)

    @app.before_request
    def _load_lang_from_cookie_shop():
        if 'lang' not in session and request.cookies.get('lang'):
            session['lang'] = request.cookies.get('lang')

    register_filters(app)

    # Register blueprint shop first so Flask matches these routes before React SPA
    app.register_blueprint(shop_bp)

    # Serve React SPA build if available
    react_dist = resource_base.parent / 'webshop' / 'dist'
    if (react_dist / 'index.html').exists():
        react_dist_path = str(react_dist)

        @app.route('/static/<path:filename>')
        def react_static(filename):
            return send_from_directory(os.path.join(react_dist_path, 'static'), filename)

        @app.route('/', defaults={'path': ''})
        @app.route('/<path:path>')
        def serve_react(path):
            if path.startswith('api/') or path.startswith('shop/') or path.startswith('placeholder'):
                return app.fallback(request.endpoint, request.view_args)
            file_path = Path(react_dist_path) / path
            if path and file_path.exists() and file_path.is_file():
                return send_from_directory(react_dist_path, path)
            return send_from_directory(react_dist_path, 'index.html')

    return app

