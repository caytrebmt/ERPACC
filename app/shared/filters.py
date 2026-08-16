from flask import session, redirect, url_for


class IndexFilterPreserver:
    _session_prefix = ''

    @classmethod
    def save(cls, **filters):
        for key, value in filters.items():
            session[f'{cls._session_prefix}{key}'] = value

    @classmethod
    def redirect(cls, endpoint, **defaults):
        params = {}
        for key, default in defaults.items():
            session_key = f'{cls._session_prefix}{key}'
            if session_key in session:
                params[key] = session[session_key]
            else:
                params[key] = default
        return redirect(url_for(endpoint, **params))


class ProductFilters(IndexFilterPreserver):
    _session_prefix = 'products_'


class CustomerFilters(IndexFilterPreserver):
    _session_prefix = 'customers_'


class SupplierFilters(IndexFilterPreserver):
    _session_prefix = 'suppliers_'


class StockOutFilters(IndexFilterPreserver):
    _session_prefix = 'stock_out_'


class StockInFilters(IndexFilterPreserver):
    _session_prefix = 'stock_in_'


class EcommerceOrderFilters(IndexFilterPreserver):
    _session_prefix = 'ecommerce_orders_'


class ShopCustomerFilters(IndexFilterPreserver):
    _session_prefix = 'shop_customers_'
