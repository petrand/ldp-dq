-- Shared LHP quarantine inbox + outbox for invoice and purchase-order joins.
-- Create these tables before deploying. Recycle is filtered by _dlq_source_table.

CREATE TABLE IF NOT EXISTS ${catalog}.${dq_schema}.invoice_join_dlq (
    _dlq_sk            STRING    NOT NULL,
    _dlq_source_table  STRING    NOT NULL,
    _dlq_status        STRING    NOT NULL,
    _dlq_timestamp     TIMESTAMP NOT NULL,
    _dlq_failed_rules  ARRAY<STRUCT<name: STRING, rule: STRING>>,
    _dlq_rescued_data  STRING,
    _row_data          VARIANT   NOT NULL
)
TBLPROPERTIES (
    'delta.enableChangeDataFeed' = 'true',
    'delta.enableRowTracking' = 'true'
);

CREATE TABLE IF NOT EXISTS ${catalog}.${dq_schema}.invoice_join_dlq_outbox (
    _dlq_sk            STRING    NOT NULL,
    _dlq_source_table  STRING    NOT NULL,
    _row_data          VARIANT   NOT NULL,
    _dlq_recycled_at   TIMESTAMP NOT NULL
)
TBLPROPERTIES (
    'delta.enableRowTracking' = 'true'
);
