MODEL (
  name star_simulator_db.raw.raw_inventory,
  kind SEED (path '../../seeds/raw/raw_inventory.csv'),
  owner 'data_team',
  tags ['standard'],
  description 'Source system extract: daily inventory position snapshots. Grain is one row per snapshot date, product, and store.',
  columns (
    snapshot_date DATE,
    product_id    INTEGER,
    store_id      INTEGER,
    qty_on_hand   INTEGER,
    qty_reserved  INTEGER
  ),
  grain (snapshot_date, product_id, store_id),
  audits (not_null(columns := [snapshot_date, product_id, store_id, qty_on_hand]))
);
