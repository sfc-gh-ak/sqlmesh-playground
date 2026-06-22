MODEL (
  name star_simulator_db.ods.stg_customers,
  kind FULL,
  owner 'data_team',
  tags ['standard'],
  description 'Cleaned customer master data. Adds full_name, normalizes tier and country to uppercase.',
  grain (customer_id),
  audits (not_null(columns := [customer_id, email, signup_date]))
);

SELECT
  customer_id::INTEGER                                          AS customer_id,
  first_name::VARCHAR                                           AS first_name,
  last_name::VARCHAR                                            AS last_name,
  (first_name::VARCHAR || ' ' || last_name::VARCHAR)::VARCHAR   AS full_name,
  LOWER(email)::VARCHAR                                         AS email,
  city::VARCHAR                                                 AS city,
  state::VARCHAR                                                AS state,
  UPPER(country)::VARCHAR                                       AS country,
  signup_date::DATE                                             AS signup_date,
  UPPER(tier)::VARCHAR                                          AS tier,
  CURRENT_TIMESTAMP                                             AS _loaded_at
FROM star_simulator_db.raw.raw_customers
