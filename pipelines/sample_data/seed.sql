-- Seed raw CDC changes for the LHP bronze SCD2 pipelines.
-- Source CSVs: pipelines/sample_data/*.csv
-- Catalog/schema match substitutions/dev.yaml for the FEVM workspace.

CREATE SCHEMA IF NOT EXISTS ssas_pbi_mv_migration_catalog.ldp_dq_raw;

CREATE TABLE IF NOT EXISTS ssas_pbi_mv_migration_catalog.ldp_dq_raw.account_customer_changes (
  account STRING,
  customer STRING,
  operation STRING,
  sequence_num BIGINT
);
CREATE TABLE IF NOT EXISTS ssas_pbi_mv_migration_catalog.ldp_dq_raw.invoice_changes (
  invoice_id STRING,
  account STRING,
  operation STRING,
  sequence_num BIGINT
);
CREATE TABLE IF NOT EXISTS ssas_pbi_mv_migration_catalog.ldp_dq_raw.purchase_order_changes (
  po_id STRING,
  account STRING,
  operation STRING,
  sequence_num BIGINT
);

TRUNCATE TABLE ssas_pbi_mv_migration_catalog.ldp_dq_raw.account_customer_changes;
TRUNCATE TABLE ssas_pbi_mv_migration_catalog.ldp_dq_raw.invoice_changes;
TRUNCATE TABLE ssas_pbi_mv_migration_catalog.ldp_dq_raw.purchase_order_changes;

INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.account_customer_changes
  (account, customer, operation, sequence_num)
VALUES
  ('ACC-100', 'Acme Corp', 'INSERT', 1),
  ('ACC-200', 'Globex Ltd', 'INSERT', 1),
  ('ACC-300', 'Initech', 'INSERT', 1),
  ('ACC-400', '', 'INSERT', 1),
  (' ', 'Orphan Co', 'INSERT', 1);

INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.invoice_changes
  (invoice_id, account, operation, sequence_num)
VALUES
  ('INV-001', 'ACC-100', 'INSERT', 1),
  ('INV-002', 'ACC-100', 'INSERT', 1),
  ('INV-003', 'ACC-200', 'INSERT', 1),
  ('INV-004', 'ACC-999', 'INSERT', 1),
  ('INV-005', 'ACC-888', 'INSERT', 1),
  ('INV-006', NULL, 'INSERT', 1),
  ('INV-007', 'ACC-300', 'INSERT', 1);

INSERT INTO ssas_pbi_mv_migration_catalog.ldp_dq_raw.purchase_order_changes
  (po_id, account, operation, sequence_num)
VALUES
  ('PO-001', 'ACC-100', 'INSERT', 1),
  ('PO-002', 'ACC-200', 'INSERT', 1),
  ('PO-003', 'ACC-777', 'INSERT', 1),
  ('PO-004', NULL, 'INSERT', 1),
  ('PO-005', 'ACC-300', 'INSERT', 1),
  ('PO-006', 'ACC-400', 'INSERT', 1);
