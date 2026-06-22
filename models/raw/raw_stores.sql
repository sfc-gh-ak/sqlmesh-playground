MODEL (
  name star_simulator_db.raw.raw_stores,
  kind SEED (path '../../seeds/raw/raw_stores.csv'),
  owner 'data_team',
  tags ['standard'],
  description 'Source system extract: store master data. Covers physical, online, outlet, and mobile channels.',
  columns (
    store_id    INTEGER,
    name        VARCHAR,
    city        VARCHAR,
    state       VARCHAR,
    country     VARCHAR,
    store_type  VARCHAR,
    opened_date DATE
  ),
  grain (store_id),
  audits (not_null(columns := [store_id, name, store_type]))
);
