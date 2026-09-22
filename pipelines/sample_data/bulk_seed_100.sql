-- Add realistic SCD2 input data:
--   50 valid account/customer mappings
--   100 invoices (95 valid, 5 expected to quarantine)
--   100 purchase orders (95 valid, 5 expected to quarantine)
--
-- Run once. These are append-only raw CDC events consumed by bronze_scd2.

INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.account_customer_changes
  (account, customer, operation, sequence_num)
SELECT
  format_string('ACC-B%03d', id) AS account,
  format_string('Demo Customer %03d', id) AS customer,
  'INSERT' AS operation,
  1 AS sequence_num
FROM range(1, 51);

INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.invoice_changes
  (invoice_id, account, operation, sequence_num)
SELECT
  format_string('INV-B%03d', id) AS invoice_id,
  CASE
    WHEN id <= 95 THEN format_string('ACC-B%03d', pmod(id - 1, 50) + 1)
    WHEN id = 96 THEN 'ACC-INV-MISSING-096'
    WHEN id = 97 THEN 'ACC-INV-MISSING-097'
    WHEN id = 98 THEN 'ACC-INV-MISSING-098'
    WHEN id = 99 THEN NULL
    WHEN id = 100 THEN ''
  END AS account,
  'INSERT' AS operation,
  1 AS sequence_num
FROM range(1, 101);

INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.purchase_order_changes
  (po_id, account, operation, sequence_num)
SELECT
  format_string('PO-B%03d', id) AS po_id,
  CASE
    WHEN id <= 95 THEN format_string('ACC-B%03d', pmod(id + 6, 50) + 1)
    WHEN id = 96 THEN 'ACC-PO-MISSING-096'
    WHEN id = 97 THEN 'ACC-PO-MISSING-097'
    WHEN id = 98 THEN 'ACC-PO-MISSING-098'
    WHEN id = 99 THEN NULL
    WHEN id = 100 THEN ''
  END AS account,
  'INSERT' AS operation,
  1 AS sequence_num
FROM range(1, 101);
