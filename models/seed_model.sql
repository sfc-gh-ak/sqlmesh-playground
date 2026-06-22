MODEL (
  name sqlmesh_example.seed_model,
  kind SEED (
    path '../seeds/seed_data.csv'
  ),
  owner 'data_team',
  tags ['standard'],
  description 'Example seed model. Loads static order event data from a CSV file.',
  columns (
    id INTEGER,
    item_id INTEGER,
    event_date DATE
  ),
  grain (id, event_date),
  audits (not_null(columns := [id, item_id, event_date]))
);
