MODEL (
  name star_simulator_db.raw.raw_products,
  kind SEED (path '../../seeds/raw/raw_products.csv'),
  owner 'data_team',
  tags ['standard'],
  description 'Source system extract: product catalog. One row per product SKU.',
  columns (
    product_id  INTEGER,
    sku         VARCHAR,
    name        VARCHAR,
    category_id INTEGER,
    brand       VARCHAR,
    cost        DOUBLE,
    list_price  DOUBLE,
    is_active   BOOLEAN
  ),
  grain (product_id),
  audits (not_null(columns := [product_id, sku, name, category_id, list_price]))
);
