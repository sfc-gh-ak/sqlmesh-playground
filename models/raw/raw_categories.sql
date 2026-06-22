MODEL (
  name star_simulator_db.raw.raw_categories,
  kind SEED (path '../../seeds/raw/raw_categories.csv'),
  owner 'data_team',
  tags ['standard'],
  description 'Source system extract: product category hierarchy. Supports two levels via parent_category_id.',
  columns (
    category_id        INTEGER,
    name               VARCHAR,
    parent_category_id INTEGER,
    department         VARCHAR
  ),
  grain (category_id),
  audits (not_null(columns := [category_id, name, department]))
);
