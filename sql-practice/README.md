# SQL Practice (Odoo 18 Demo Database)

## Files

- `00_explore.sql` — Basic exploratory queries inspecting `res_partner` and `account_move`.
- `01_invoices_per_customer.sql` — Aggregates posted customer invoice counts and total revenue per customer (`INNER JOIN` + `GROUP BY`).
- `02_top_products_by_qty.sql` — Finds top 10 products by quantity sold on confirmed sales orders across 4 joined tables (`JSONB` extraction).
- `03_customers_without_orders.sql` — Lists companies that have never placed a sales order (`LEFT JOIN ... IS NULL`).
- `04_monthly_revenue.sql` — Summarizes monthly posted customer invoice counts and revenue (`date_trunc` + `GROUP BY`).
- `05_customer_rank_window.sql` — Ranks customers by total revenue and calculates each customer's percentage share using window functions (`RANK() OVER`, `SUM() OVER`).
- `06_index_test.sql` — Benchmarks PostgreSQL query plans and execution times before and after creating B-tree indexes on a 200,000-row practice table (`invoice_test`).

## Index Benchmark (`06_index_test.sql`)

| Query | Description | Rows Matched | Before Index (`Seq Scan`) | After Index (`Bitmap Heap Scan`) | Speedup |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **Query A** | `WHERE partner_id = 1234` (Selective lookup + `SUM`) | 47 / 200,000 (~0.02%) | 19.764 ms | 0.123 ms | ~161x faster |
| **Query B** | `WHERE invoice_date >= current_date - 30` (30-day range) | 8,449 / 200,000 (~4.2%) | 34.635 ms | 3.414 ms | ~10x faster |

**Takeaway:** Indexes give the biggest speedup on highly selective queries that fetch a tiny fraction of rows (like Query A touching 46 table pages), whereas range queries returning thousands of rows scattered across most of the table's pages (Query B touching 1,467 of 1,471 pages) still have to read almost the entire table from disk.
