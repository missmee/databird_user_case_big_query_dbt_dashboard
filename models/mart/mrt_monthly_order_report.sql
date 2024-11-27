SELECT 
  DATE_TRUNC(o.order_date, MONTH) AS report_date,
  COUNT(DISTINCT o.order_id) AS total_nb_of_orders,
  ROUND(SUM(o.total_order_amount),2) AS total_monthly_order_amount,
  ROUND(AVG(o.total_order_amount),2) AS average_total_order_amount,
  ROUND(AVG(o.total_distinct_items),2) AS average_total_distinct_items,
  ROUND(SUM(o.total_order_amount) / COUNT(DISTINCT o.order_id), 2) AS average_per_order,
  COUNT(CASE WHEN o.customer_status = 'New client' THEN 1 ELSE NULL END) / AS nb_of_new_clients,
  COUNT(DISTINCT item_quantity_low_in_stock) AS nb_of_items_low_in_stock,
  stk.store_name AS store_name,
  stk.store_city AS store_city
FROM {{ ref("int_local_bike__orders") }} AS o
LEFT JOIN {{ ref("int_local_bike__stocks") }} AS stk ON stk.store_id = o.store_id
GROUP BY 
  DATE_TRUNC(o.order_date, MONTH),
  stk.store_name,
  stk.store_city