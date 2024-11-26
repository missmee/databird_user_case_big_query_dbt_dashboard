WITH favorite_brand AS (
SELECT
  o.customer_id,
  o.store_id,
  oi.brand_id AS favorite_brand_id,
  oi.brand_name,
  oi.product_name,
  o.customer_status
FROM {{ ref('int_local_bike__order_items') }} AS oi
LEFT JOIN {{ ref('int_local_bike__orders') }} AS o ON oi.order_id = o.order_id
GROUP BY
  o.customer_id,
  o.store_id,
  oi.brand_id,
  oi.brand_name,
  oi.product_name,
  o.customer_status
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY o.customer_id
  ORDER BY SUM(oi.item_quantity) DESC
) = 1
),

favorite_product AS (
SELECT
  o.customer_id,
  o.store_id,
  oi.product_id AS favorite_product_id,
  oi.brand_name,
  oi.product_name,
  o.customer_status
FROM {{ ref('int_local_bike__order_items') }} AS oi
LEFT JOIN {{ ref('int_local_bike__orders') }} AS o ON oi.order_id = o.order_id
GROUP BY
  o.customer_id,
  o.store_id,
  oi.product_id,
  oi.brand_name,
  oi.product_name,
  o.customer_status
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY o.customer_id
  ORDER BY SUM(oi.item_quantity) DESC
) = 1
)

SELECT 
  fb.customer_id,
  fb.store_id,
  favorite_brand_id,
  favorite_product_id,
  fb.brand_name,
  fb.product_name
FROM favorite_brand AS fb 
INNER JOIN favorite_product AS fp ON fb.customer_id = fp.customer_id
WHERE fb.customer_status = 'Past client'