-- Correct raw CDC data and emit new fact versions so failed rows are rechecked.
-- Run bronze_scd2 first, then the silver invoice/PO pipelines.

-- Fix/add lookup versions.
INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.account_customer_changes
  (account, customer, operation, sequence_num)
VALUES
  ('ACC-999', 'NewCo 999', 'INSERT', 2),
  ('ACC-888', 'NewCo 888', 'INSERT', 2),
  ('ACC-777', 'NewCo 777', 'INSERT', 2),
  ('ACC-400', 'Wayne Enterprises', 'UPDATE', 2);

-- Reissue failed invoice keys as newer SCD2 versions. The mapping-only change
-- does not itself produce an invoice event, so this touch triggers join + DQ.
INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.invoice_changes
  (invoice_id, account, operation, sequence_num)
VALUES
  ('INV-004', 'ACC-999', 'UPDATE', 2),
  ('INV-005', 'ACC-888', 'UPDATE', 2),
  ('INV-006', 'ACC-100', 'UPDATE', 2);

-- Reissue failed PO keys as newer SCD2 versions.
INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.purchase_order_changes
  (po_id, account, operation, sequence_num)
VALUES
  ('PO-003', 'ACC-777', 'UPDATE', 2),
  ('PO-004', 'ACC-100', 'UPDATE', 2),
  ('PO-006', 'ACC-400', 'UPDATE', 2);
