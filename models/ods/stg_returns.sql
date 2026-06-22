MODEL (
  name star_simulator_db.ods.stg_returns,
  kind FULL,
  owner 'data_team',
  tags ['standard'],
  description 'Cleaned return and refund records. Normalizes reason to uppercase.',
  grain (return_id),
  audits (not_null(columns := [return_id, order_id, item_id, return_date, refund_amount]))
);

SELECT
  return_id::INTEGER                AS return_id,
  order_id::INTEGER                 AS order_id,
  item_id::INTEGER                  AS item_id,
  UPPER(reason)::VARCHAR            AS reason,
  return_date::DATE                 AS return_date,
  refund_amount::DOUBLE             AS refund_amount,
  CURRENT_TIMESTAMP                 AS _loaded_at
FROM star_simulator_db.raw.raw_returns
