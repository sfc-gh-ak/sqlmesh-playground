MODEL (
  name star_simulator_db.ods.stg_products,
  kind FULL,
  owner 'data_team',
  tags ['standard'],
  description 'Cleaned product catalog. Normalizes brand casing and adds margin calculation.',
  grain (product_id),
  audits (not_null(columns := [product_id, sku, name, category_id, list_price]))
);

SELECT
  product_id::INTEGER                                       AS product_id,
  sku::VARCHAR                                              AS sku,
  name::VARCHAR                                             AS name,
  category_id::INTEGER                                      AS category_id,
  INITCAP(brand)::VARCHAR                                   AS brand,
  cost::DOUBLE                                              AS cost,
  list_price::DOUBLE                                        AS list_price,
  ROUND(list_price::DOUBLE - cost::DOUBLE, 2)               AS gross_margin,
  ROUND((list_price::DOUBLE - cost::DOUBLE)
        / NULLIF(list_price::DOUBLE, 0) * 100, 2)           AS margin_pct,
  is_active::BOOLEAN                                        AS is_active,
  CURRENT_TIMESTAMP                                         AS _loaded_at
FROM star_simulator_db.raw.raw_products
