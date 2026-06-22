MODEL (
  name sqlmesh_example.full_model,
  kind FULL,
  cron '@daily',
  owner 'data_team',
  tags ['standard'],
  description 'Example full model. Aggregates order counts per item from the incremental model.',
  grain item_id,
  audits (assert_positive_order_ids, not_null(columns := [item_id, num_orders]))
);

SELECT
  item_id,
  COUNT(DISTINCT id) AS num_orders,
FROM
  sqlmesh_example.incremental_model
GROUP BY item_id
