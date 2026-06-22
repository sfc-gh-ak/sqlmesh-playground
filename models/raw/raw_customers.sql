MODEL (
  name star_simulator_db.raw.raw_customers,
  kind SEED (path '../../seeds/raw/raw_customers.csv'),
  owner 'data_team',
  tags ['standard'],
  description 'Source system extract: customer master data. One row per customer.',
  columns (
    customer_id INTEGER,
    first_name  VARCHAR,
    last_name   VARCHAR,
    email       VARCHAR,
    city        VARCHAR,
    state       VARCHAR,
    country     VARCHAR,
    signup_date DATE,
    tier        VARCHAR
  ),
  grain (customer_id),
  audits (not_null(columns := [customer_id, email, signup_date]))
);
