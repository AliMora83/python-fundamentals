# python-fundamentals

Python and SQL practice outside Odoo: typed dataclasses, input validation, pytest, and PostgreSQL queries with measured index performance. Part of a 13-week developer plan.

## What's here

| Path | What it covers |
|---|---|
| [`invoice.py`](invoice.py) | `Invoice` and `LineItem` dataclasses with type hints, validation in `__post_init__`, and subtotal, tax and total rounded to cents |
| [`test_invoice.py`](test_invoice.py) | 13 pytest tests: fixtures, `pytest.raises` with message matching, and `parametrize` |
| [`sql-practice/`](sql-practice/) | Seven PostgreSQL scripts against an Odoo 18 demo database: joins, aggregates, window functions, and an index benchmark |

## Run the tests

Needs Python 3.10 or newer.

```bash
git clone https://github.com/AliMora83/python-fundamentals.git
cd python-fundamentals
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pytest
```

## Example

```python
from invoice import Invoice

inv = Invoice("Acme")
inv.add_line("Widget", 2, 100.0)
inv.add_line("Gadget", 1, 50.0)

inv.subtotal()  # 250.0
inv.tax()       # 37.5 (default rate 15%)
inv.total()     # 287.5
```

A quantity of zero or less, a negative price, or a negative tax rate raises `ValueError`.

## SQL highlight

`sql-practice/06_index_test.sql` times two queries on a 200,000-row table before and after adding B-tree indexes.

| Query | Before index | After index |
|---|---|---|
| Selective lookup (47 rows) | 19.764 ms | 0.123 ms |
| 30-day date range (8,449 rows) | 34.635 ms | 3.414 ms |

The full write-up is in [`sql-practice/README.md`](sql-practice/README.md).
