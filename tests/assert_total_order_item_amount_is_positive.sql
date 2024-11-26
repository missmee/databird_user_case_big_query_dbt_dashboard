SELECT
  order_item_id,
  SUM(total_order_item_amount) AS total_amount
FROM {{ ref('stg_local_bike__order_items') }}
GROUP BY order_item_id
HAVING total_amount < 0