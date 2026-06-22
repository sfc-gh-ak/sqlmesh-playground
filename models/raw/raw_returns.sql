MODEL (
  name star_simulator_db.raw.raw_returns,
  kind SEED (path '../../seeds/raw/raw_returns.csv'),
  owner 'data_team',
  tags ['standard'],
  description 'Source system extract: return and refund records. Each row is a single returned line item.',
  columns (
    return_id     INTEGER,
    order_id      INTEGER,
    item_id       INTEGER,
    reason        VARCHAR,
    return_date   DATE,
    refund_amount DOUBLE
  ),
  grain (return_id),
  audits (not_null(columns := [return_id, order_id, item_id, reason, return_date, refund_amount]))
);
