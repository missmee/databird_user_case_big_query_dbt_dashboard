-- gathering together in order_item the missing information about item product name and brand
-- joing the two differents tables where the information is (products and brands)
-- now we have all the information about items in the same view
SELECT order_item_id,
  order_id,
  oi.item_quantity,
  oi.product_id,
  p.product_name,
  b.brand_id,
  b.brand_name
FROM
{{ ref('stg_local_bike__order_items') }} AS oi
INNER JOIN {{ ref('stg_local_bike__products') }} AS p ON p.product_id = oi.product_id
INNER JOIN {{ ref('stg_local_bike__brands') }} b ON b.brand_id = p.brand_id