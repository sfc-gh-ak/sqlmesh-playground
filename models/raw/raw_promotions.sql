MODEL (
  name star_simulator_db.raw.raw_promotions,
  kind SEED (path '../../seeds/raw/raw_promotions.csv'),
  owner 'data_team',
  tags ['standard'],
  description 'Source system extract: promotional campaigns. Includes percentage and fixed-amount discount types.',
  columns (
    promo_id       INTEGER,
    name           VARCHAR,
    discount_type  VARCHAR,
    discount_value DOUBLE,
    start_date     DATE,
    end_date       DATE
  ),
  grain (promo_id),
  audits (not_null(columns := [promo_id, name, discount_type, discount_value, start_date, end_date]))
);
