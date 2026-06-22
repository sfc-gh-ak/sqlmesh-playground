MODEL (
  name star_simulator_db.raw.raw_order_items,
  kind SEED (path '../../seeds/raw/raw_order_items.csv'),
  owner 'data_team',
  tags ['standard'],
  description 'Source system extract: order line items. One row per item within an order.',
  columns (
    item_id         INTEGER,
    order_id        INTEGER,
    product_id      INTEGER,
    quantity        INTEGER,
    unit_price      DOUBLE,
    discount_amount DOUBLE
  ),
  grain (item_id),
  audits (not_null(columns := [item_id, order_id, product_id, quantity, unit_price]))
);
