MODEL (
  name star_simulator_db.ods.stg_promotions,
  kind FULL,
  owner 'data_team',
  tags ['standard'],
  description 'Cleaned promotions data. Normalizes discount_type to uppercase and adds is_active flag.',
  grain (promo_id),
  audits (not_null(columns := [promo_id, name, discount_type, discount_value, start_date, end_date]))
);

SELECT
  promo_id::INTEGER                                     AS promo_id,
  name::VARCHAR                                         AS name,
  UPPER(discount_type)::VARCHAR                         AS discount_type,
  discount_value::DOUBLE                                AS discount_value,
  start_date::DATE                                      AS start_date,
  end_date::DATE                                        AS end_date,
  (CURRENT_DATE BETWEEN start_date::DATE AND end_date::DATE)::BOOLEAN AS is_active,
  CURRENT_TIMESTAMP                                     AS _loaded_at
FROM star_simulator_db.raw.raw_promotions
