-- 06_index_test.sql
-- Learning PostgreSQL indexes by comparing EXPLAIN ANALYZE before and after creating indexes.

-- 1. Drop and recreate a standalone practice table (does not touch Odoo tables)
DROP TABLE IF EXISTS invoice_test;

CREATE TABLE invoice_test (
    id serial PRIMARY KEY,
    partner_id int,
    state text,
    amount numeric,
    invoice_date date
);

-- 2. Insert 200,000 synthetic rows using generate_series
-- partner_id: random integer from 1 to 5000
-- state: randomly 'draft' or 'posted'
-- amount: random numeric from 0.00 to 10000.00
-- invoice_date: random date within the last 2 years (730 days)
INSERT INTO invoice_test (partner_id, state, amount, invoice_date)
SELECT
    floor(random() * 5000 + 1)::int,
    CASE WHEN random() < 0.5 THEN 'draft' ELSE 'posted' END,
    round((random() * 10000)::numeric, 2),
    current_date - floor(random() * 730)::int
FROM generate_series(1, 200000);

-- 3. Update table statistics so the query planner knows the row count and data distribution
ANALYZE invoice_test;

-- 4. BEFORE INDEXES: Run Query A and Query B with EXPLAIN ANALYZE
-- Query A: Selective lookup for a single partner (~40 rows out of 200,000, or ~0.02% of the table)
EXPLAIN ANALYZE SELECT partner_id, SUM(amount) FROM invoice_test WHERE partner_id = 1234 GROUP BY partner_id;

-- Query B: Date range lookup for the last 30 days (~8,200 rows out of 200,000, or ~4.1% of the table)
EXPLAIN ANALYZE SELECT * FROM invoice_test WHERE invoice_date >= current_date - 30;

-- 5. Create B-tree indexes on partner_id and invoice_date
CREATE INDEX idx_invoice_test_partner ON invoice_test(partner_id);
CREATE INDEX idx_invoice_test_date ON invoice_test(invoice_date);

-- 6. Refresh statistics after adding indexes
ANALYZE invoice_test;

-- 7. AFTER INDEXES: Re-run Query A and Query B to compare plans and execution times
-- Query A (with index on partner_id)
EXPLAIN ANALYZE SELECT partner_id, SUM(amount) FROM invoice_test WHERE partner_id = 1234 GROUP BY partner_id;

-- Query B (with index on invoice_date)
EXPLAIN ANALYZE SELECT * FROM invoice_test WHERE invoice_date >= current_date - 30;
