MODEL (
  name star_simulator_db.raw.raw_orders,
  kind SEED (path '../../seeds/raw/raw_orders.csv'),
  owner 'data_team',
  tags ['standard'],
  description 'Source system extract: order headers. Simulates operational DB CDC output. One row per order.',
  columns (
    order_id    INTEGER,
    customer_id INTEGER,
    store_id    INTEGER,
    promo_id    INTEGER,
    channel     VARCHAR,
    status      VARCHAR,
    order_date  DATE,
    updated_at  TIMESTAMP
  ),
  grain (order_id),
  audits (not_null(columns := [order_id, customer_id, store_id, order_date]))
);
