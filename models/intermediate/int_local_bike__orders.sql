WITH 
items_grouped_by_order AS (
    SELECT 
      oi.order_id,
      o.order_status,
      o.order_date,
      o.customer_id,
      o.store_id,
      SUM(total_order_item_amount) AS total_order_amount,
      SUM(item_quantity) AS total_items,
      COUNT(DISTINCT oi.product_id) AS total_distinct_items
    FROM {{ ref('stg_local_bike__order_items') }} AS oi
    INNER JOIN {{ ref('stg_local_bike__orders') }} o ON oi.order_id = o.order_id  
    GROUP BY oi.order_id, 
        o.order_status, 
        o.order_date,
        o.store_id,
        o.customer_id
),

customer_status AS (
    SELECT 
        o.order_id,
        o.customer_id,
        o.order_date,
        ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS order_rank,  -- Classement des commandes
        COUNT(*) OVER (PARTITION BY o.customer_id) AS total_orders,  -- Total commandes
        EXTRACT(YEAR FROM o.order_date) AS order_year,
        EXTRACT(MONTH FROM o.order_date) AS order_month,
        CASE 
            WHEN ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) = 1 THEN 'New customer'
            WHEN COUNT(*) OVER (PARTITION BY o.customer_id) = 1 THEN 'Unique order customer'
            ELSE 'Recurrent customer'
        END AS customer_status
    FROM {{ ref("stg_local_bike__orders") }} o
)

-- Requête finale
SELECT
  igo.order_id,
  igo.order_status,
  igo.order_date,
  igo.store_id,
  COALESCE(igo.total_order_amount, 0) AS total_order_amount,
  COALESCE(igo.total_items, 0) AS total_items,
  COALESCE(igo.total_distinct_items, 0) AS total_distinct_items,
  cs.order_year,
  cs.order_month,
  cs.customer_id,
  cs.customer_status
FROM items_grouped_by_order AS igo 
LEFT JOIN customer_status AS cs ON igo.order_id = cs.order_id