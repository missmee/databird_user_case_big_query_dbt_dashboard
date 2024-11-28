-- asserting the brand each past customer per store mostly bought (by quantity). 
-- Looking for product or brand fidelity among past customers
WITH favorite_brand AS (
SELECT
  o.customer_id,
  o.store_id,
  oi.brand_id AS favorite_brand_id,
  oi.brand_name,
  o.customer_status
FROM {{ ref('int_local_bike__order_items') }} AS oi
LEFT JOIN {{ ref('int_local_bike__orders') }} AS o ON oi.order_id = o.order_id
WHERE o.customer_status = 'Past client'
GROUP BY
  o.customer_id,
  o.store_id,
  oi.brand_id,
  oi.brand_name,
  o.customer_status
-- I sum item quantity, partition by customer and keep only the top 1 brand
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY o.customer_id
  ORDER BY SUM(oi.item_quantity) DESC
) = 1
),

-- asserting the product each client per store mostly bought (by quantity)
favorite_product AS (
SELECT
  o.customer_id,
  o.store_id,
  oi.product_id AS favorite_product_id,
  oi.product_name,
  o.customer_status
FROM {{ ref('int_local_bike__order_items') }} AS oi
LEFT JOIN {{ ref('int_local_bike__orders') }} AS o ON oi.order_id = o.order_id
WHERE o.customer_status = 'Past client'
GROUP BY
  o.customer_id,
  o.store_id,
  oi.product_id,
  oi.product_name,
  o.customer_status
-- I sum item quantity, partition by customer and keep only the top 1 brand
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
-- double ON join in case a customer bought in 2 different stores
INNER JOIN favorite_product AS fp ON fb.customer_id = fp.customer_id AND fb.store_id = fp.store_id