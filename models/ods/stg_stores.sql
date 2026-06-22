MODEL (
  name star_simulator_db.ods.stg_stores,
  kind FULL,
  owner 'data_team',
  tags ['standard'],
  description 'Cleaned store master data. Normalizes store_type and country to uppercase.',
  grain (store_id),
  audits (not_null(columns := [store_id, name, store_type]))
);

SELECT
  store_id::INTEGER           AS store_id,
  name::VARCHAR               AS name,
  city::VARCHAR               AS city,
  state::VARCHAR              AS state,
  country::VARCHAR            AS country,
  UPPER(store_type)::VARCHAR  AS store_type,
  opened_date::DATE           AS opened_date,
  CURRENT_TIMESTAMP           AS _loaded_at
FROM star_simulator_db.raw.raw_stores
