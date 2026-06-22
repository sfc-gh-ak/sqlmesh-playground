MODEL (
  name star_simulator_db.ods.stg_order_items,
  kind FULL,
  owner 'data_team',
  tags ['standard'],
  description 'Cleaned order line items. Adds line_total and discounted_total as derived measures.',
  grain (item_id),
  audits (not_null(columns := [item_id, order_id, product_id, quantity, unit_price]))
);

SELECT
  item_id::INTEGER                                                          AS item_id,
  order_id::INTEGER                                                         AS order_id,
  product_id::INTEGER                                                       AS product_id,
  quantity::INTEGER                                                         AS quantity,
  unit_price::DOUBLE                                                        AS unit_price,
  discount_amount::DOUBLE                                                   AS discount_amount,
  ROUND(unit_price::DOUBLE * quantity::INTEGER, 2)                          AS line_total,
  ROUND((unit_price::DOUBLE - discount_amount::DOUBLE) * quantity::INTEGER, 2) AS discounted_total,
  CURRENT_TIMESTAMP                                                         AS _loaded_at
FROM star_simulator_db.raw.raw_order_items
