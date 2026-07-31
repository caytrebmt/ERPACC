from decimal import Decimal

from app.domains.sales.services.profit_metrics import (
    calculate_cogs,
    calculate_net_revenue,
    calculate_profit,
)


def test_net_revenue_excludes_vat_and_uses_discount():
    assert calculate_net_revenue(1_000_000, 100_000) == Decimal("900000.00")
    assert calculate_net_revenue(1_000, 5_000) == Decimal("0.00")


def test_cogs_uses_quantity_conversion_and_unit_cost():
    assert calculate_cogs(2, 1.5, 100_000, 0) == Decimal("300000.00")
    assert calculate_cogs(3, 1, 0, 50_000) == Decimal("150000.00")


def test_profit_is_revenue_minus_cogs():
    assert calculate_profit(1_000_000, 700_000) == Decimal("300000.00")
