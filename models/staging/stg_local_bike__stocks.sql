SELECT
  store_id,
  product_id,
  quantity AS item_quantity_in_stock
FROM {{ source ("local_bike", "stocks") }}