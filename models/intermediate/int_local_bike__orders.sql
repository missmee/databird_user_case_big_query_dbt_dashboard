-- gathering all the info we need about orders by joining order_items and orders,
-- including calculated info about the total amount for each order, the number of items and of distinct items.
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

-- Clustering customers between new clients (who ordered for the first time in a given month)
-- and returning clients who ordered more than a month ago.
-- This CTE classifies customers as either 'New client' or 'Past client'
customer_status_definition AS (
  SELECT 
    customer_id,
    EXTRACT(YEAR FROM MIN(order_date)) AS year,          -- Year of the first order
    EXTRACT(MONTH FROM MIN(order_date)) AS month,        -- Month of the first order
    MIN(order_date) AS first_order_date,                 -- Date of the first order
    CASE 
      WHEN EXTRACT(YEAR FROM MIN(order_date)) = 2018 AND EXTRACT(MONTH FROM MIN(order_date)) = 04 THEN 'New client' 
          ELSE 'Past client'
        END AS customer_status
  FROM {{ ref("stg_local_bike__orders") }}
  GROUP BY customer_id
)

-- Final query to select all the relevant order information along with customer status
SELECT
  oi.order_id,
  oi.order_status,
  oi.order_date,
  oi.store_id,
  COALESCE(oi.total_order_amount, 0) AS total_order_amount,
  COALESCE(oi.total_items, 0) AS total_items,
  COALESCE(oi.total_distinct_items, 0) AS total_distinct_items,
  c.customer_id,
  c.customer_status
FROM items_grouped_by_order AS oi 
LEFT JOIN customer_status_definition AS c ON oi.customer_id = c.customer_id
