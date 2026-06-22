MODEL (
  name star_simulator_db.ods.stg_orders,
  kind FULL,
  owner 'data_team',
  tags ['standard'],
  description 'Cleaned order headers. Normalizes channel and status to uppercase. Adds is_cancelled and is_returned flags.',
  grain (order_id),
  audits (not_null(columns := [order_id, customer_id, store_id, order_date]))
);

SELECT
  order_id::INTEGER                                         AS order_id,
  customer_id::INTEGER                                      AS customer_id,
  store_id::INTEGER                                         AS store_id,
  promo_id::INTEGER                                         AS promo_id,
  UPPER(channel)::VARCHAR                                   AS channel,
  UPPER(status)::VARCHAR                                    AS status,
  order_date::DATE                                          AS order_date,
  updated_at::TIMESTAMP                                     AS updated_at,
  (UPPER(status) = 'CANCELLED')::BOOLEAN                    AS is_cancelled,
  (UPPER(status) = 'RETURNED')::BOOLEAN                     AS is_returned,
  CURRENT_TIMESTAMP                                         AS _loaded_at
FROM star_simulator_db.raw.raw_orders
