SELECT CONCAT(order_id, '_', product_id) AS order_item_id,
  order_id,
  product_id,
  list_price AS item_price,
  quantity AS item_quantity,
  (list_price * quantity) * (1 - discount)  AS total_order_item_amount
FROM {{ source('local_bike', 'order_items') }}