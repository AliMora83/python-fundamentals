import pytest

from invoice import Invoice, LineItem


# A fixture is reusable setup. Any test that takes "invoice" as an
# argument gets a fresh Invoice with two lines, so tests never share state.
@pytest.fixture
def invoice() -> Invoice:
    inv = Invoice("Acme")
    inv.add_line("Widget", 2, 100.0)   # 200
    inv.add_line("Gadget", 1, 50.0)    # 50
    return inv


# Test names start with test_ so pytest finds them automatically.
def test_line_item_total() -> None:
    item = LineItem("Widget", 3, 10.0)
    assert item.total() == 30.0         # assert = "this must be true"


def test_empty_invoice_subtotal_is_zero() -> None:
    assert Invoice("Empty").subtotal() == 0


def test_add_line_appends(invoice: Invoice) -> None:
    assert len(invoice.lines) == 2
    assert invoice.lines[0].description == "Widget"


def test_subtotal(invoice: Invoice) -> None:
    assert invoice.subtotal() == 250.0


def test_tax_default_rate(invoice: Invoice) -> None:
    assert invoice.tax() == 37.5        # 250 * 0.15


def test_tax_custom_rate(invoice: Invoice) -> None:
    assert invoice.tax(rate=0.10) == 25.0


def test_total(invoice: Invoice) -> None:
    assert invoice.total() == 287.5     # 250 + 37.5


def test_rounding_to_cents() -> None:
    inv = Invoice("Acme")
    inv.add_line("Tiny", 3, 0.1)        # 0.1 * 3 = 0.30000000000000004 in floats
    assert inv.subtotal() == 0.3


# pytest.raises passes only if the code inside the "with" block raises
# that exact error. match= checks the message too.
def test_zero_qty_raises() -> None:
    with pytest.raises(ValueError, match="qty"):
        LineItem("Bad", 0, 10.0)


# parametrize runs the same test once per value: 3 tests from one function.
@pytest.mark.parametrize("price", [-1.0, -0.01, -100.0])
def test_negative_price_raises(price: float) -> None:
    with pytest.raises(ValueError, match="unit_price"):
        LineItem("Bad", 1, price)


def test_negative_tax_rate_raises(invoice: Invoice) -> None:
    with pytest.raises(ValueError):
        invoice.tax(rate=-0.15)