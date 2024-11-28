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
      COUNT(DISTINCT oi. product_id) AS total_distinct_items
    FROM {{ ref('stg_local_bike__order_items') }} AS oi
    INNER JOIN {{ ref('stg_local_bike__orders') }} o ON oi.order_id = o.order_id    
    GROUP BY oi.order_id, 
        o.order_status, 
        o.order_date,
        o.store_id,
        o.customer_id
),

-- clustering customers between new clients who ordered for the 1st in the current month
-- and returning clients who already ordered more than a month ago.
-- Saved in customer_status past/new
customer_status_definition AS (
  SELECT 
    customer_id,
    EXTRACT(YEAR FROM MIN(order_date)) AS year,
    EXTRACT(MONTH FROM MIN(order_date)) AS month,
    CASE 
      WHEN EXTRACT(YEAR FROM MIN(order_date)) = 2018                    -- static info, not extracting current month for the exercice as it is 
        AND EXTRACT(MONTH FROM MIN(order_date)) = 04 THEN 'New client'  -- old data. Excluding the bugging data from May 2018 onwards
      ELSE 'Past client'
    END AS customer_status
  FROM {{ ref("stg_local_bike__orders") }}
  GROUP BY customer_id
)

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
WHERE oi.order_date <= '2018-04-30' -- I'm limiting myself to this date because the data is patchy after that