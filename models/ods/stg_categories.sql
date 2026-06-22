MODEL (
  name star_simulator_db.ods.stg_categories,
  kind FULL,
  owner 'data_team',
  tags ['standard'],
  description 'Cleaned product category hierarchy. Adds is_top_level flag and normalizes name casing.',
  grain (category_id),
  audits (not_null(columns := [category_id, name, department]))
);

SELECT
  category_id::INTEGER                                  AS category_id,
  INITCAP(name)::VARCHAR                                AS name,
  parent_category_id::INTEGER                           AS parent_category_id,
  UPPER(department)::VARCHAR                            AS department,
  (parent_category_id IS NULL)::BOOLEAN                 AS is_top_level,
  CURRENT_TIMESTAMP                                     AS _loaded_at
FROM star_simulator_db.raw.raw_categories
