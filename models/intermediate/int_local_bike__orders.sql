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

-- Identifying new customers, customers who ordered once and recurrent customers
-- How customers ordered: month of first order and total number of orders
WITH customer_orders AS (
    SELECT 
        customer_id,
        order_date,
        EXTRACT(YEAR FROM order_date) AS order_year,
        EXTRACT(MONTH FROM order_date) AS order_month,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_rank, -- Classement des commandes d’un client
        COUNT(*) OVER (PARTITION BY customer_id) AS total_orders -- Nombre total de commandes d’un client
    FROM {{ ref("stg_local_bike__orders") }}
),

customer_status_definition AS (
SELECT 
        customer_id,
        order_date,
        order_year,
        order_month,
        order_rank,
        total_orders,
        CASE 
            -- First month ordering
            WHEN order_rank = 1 THEN 'New customer'
            -- Customers with only one order overall
            WHEN total_orders = 1 THEN 'Unique order customer'
            -- Reccurent customers with several orders
            ELSE 'Recurrent customer'
        END AS customer_status
    FROM customer_orders
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
  order_year,
  order_month,
  c.customer_id,
  c.customer_status
FROM items_grouped_by_order AS oi 
LEFT JOIN customer_orders AS co ON co.customer_id = c.customer_id
LEFT JOIN customer_status_definition AS c ON oi.customer_id = c.customer_id
