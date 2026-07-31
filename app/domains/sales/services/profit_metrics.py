from decimal import Decimal, ROUND_HALF_UP
from sqlalchemy import case, func

from app.domains.inventory.models import StockOut, StockOutItem
from app.domains.master.models import Product

MONEY = Decimal("0.01")


def _money(value):
    return Decimal(str(value or 0)).quantize(MONEY, rounding=ROUND_HALF_UP)


def calculate_net_revenue(subtotal, discount_amount):
    subtotal_value = _money(subtotal)
    discount_value = _money(discount_amount)
    return max(subtotal_value - discount_value, Decimal("0"))


def calculate_cogs(quantity, conversion_factor, cost_price, fallback_cost_price=0):
    qty = _money(quantity)
    factor = _money(conversion_factor or 1)
    unit_cost = _money(cost_price)
    if unit_cost == Decimal("0"):
        unit_cost = _money(fallback_cost_price)
    return max(qty * factor * unit_cost, Decimal("0"))


def calculate_profit(revenue, cogs):
    return _money(revenue) - _money(cogs)


def build_net_revenue_expr(stock_out_model=StockOut):
    return func.coalesce(stock_out_model.subtotal, 0) - func.coalesce(stock_out_model.discount_amount, 0)


def build_cogs_expr(stock_out_item_model=StockOutItem, product_model=Product):
    unit_cost = case(
        (stock_out_item_model.cost_price > 0, stock_out_item_model.cost_price),
        else_=func.coalesce(product_model.purchase_price, 0),
    )
    return (
        func.coalesce(stock_out_item_model.quantity, 0)
        * func.coalesce(stock_out_item_model.conversion_factor, 1)
        * unit_cost
    )
