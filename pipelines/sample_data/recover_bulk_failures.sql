-- Append-only recovery example for four quarantined records.
--
-- After running this SQL:
--   1. Run bronze_scd2.
--   2. Run silver_invoice_customer.
--   3. Run silver_purchase_order.
--
-- The map correction alone does not emit a fact event. The sequence-2 fact
-- touches below create new current bronze SCD2 versions and trigger join DQ.

-- Add mappings for two missing invoice accounts and two missing PO accounts.
INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.account_customer_changes
  (account, customer, operation, sequence_num)
VALUES
  ('ACC-INV-MISSING-096', 'Recovered Invoice Customer 096', 'INSERT', 1),
  ('ACC-INV-MISSING-097', 'Recovered Invoice Customer 097', 'INSERT', 1),
  ('ACC-PO-MISSING-096', 'Recovered PO Customer 096', 'INSERT', 1),
  ('ACC-PO-MISSING-097', 'Recovered PO Customer 097', 'INSERT', 1);

-- Reissue two failed invoices as newer SCD2 versions.
INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.invoice_changes
  (invoice_id, account, operation, sequence_num)
VALUES
  ('INV-B096', 'ACC-INV-MISSING-096', 'UPDATE', 2),
  ('INV-B097', 'ACC-INV-MISSING-097', 'UPDATE', 2);

-- Reissue two failed purchase orders as newer SCD2 versions.
INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.purchase_order_changes
  (po_id, account, operation, sequence_num)
VALUES
  ('PO-B096', 'ACC-PO-MISSING-096', 'UPDATE', 2),
  ('PO-B097', 'ACC-PO-MISSING-097', 'UPDATE', 2);

-- Six intentional fact failures remain for additional recovery testing:
-- INV-B098, INV-B099, INV-B100, PO-B098, PO-B099, PO-B100.
