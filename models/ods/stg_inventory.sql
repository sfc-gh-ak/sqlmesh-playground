MODEL (
  name star_simulator_db.ods.stg_inventory,
  kind FULL,
  owner 'data_team',
  tags ['standard'],
  description 'Cleaned inventory snapshots. Adds available_qty as qty_on_hand minus qty_reserved.',
  grain (snapshot_date, product_id, store_id),
  audits (not_null(columns := [snapshot_date, product_id, store_id, qty_on_hand]))
);

SELECT
  snapshot_date::DATE                                         AS snapshot_date,
  product_id::INTEGER                                         AS product_id,
  store_id::INTEGER                                           AS store_id,
  qty_on_hand::INTEGER                                        AS qty_on_hand,
  qty_reserved::INTEGER                                       AS qty_reserved,
  GREATEST(qty_on_hand::INTEGER - qty_reserved::INTEGER, 0)   AS available_qty,
  CURRENT_TIMESTAMP                                           AS _loaded_at
FROM star_simulator_db.raw.raw_inventory
