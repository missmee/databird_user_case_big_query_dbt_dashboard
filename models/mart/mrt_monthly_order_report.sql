-- gathering the info for the report in order in the :
-- everything about orders: date, total monthly amount, nb of items & distinct items, average amout for each order
-- share of new customers in %
-- overall number of products low in stocks
-- grouped by store, city
SELECT 
  DATE_TRUNC(o.order_date, MONTH) AS report_date,
  COUNT(DISTINCT o.order_id) AS total_nb_of_orders,
  ROUND(SUM(o.total_order_amount),2) AS total_monthly_order_amount,
  ROUND(AVG(o.total_items),2) AS average_items,
  ROUND(AVG(o.total_distinct_items),2) AS average_total_distinct_items,
  ROUND(SUM(o.total_order_amount) / COUNT(DISTINCT o.order_id), 2) AS average_per_order,
  (COUNT(CASE WHEN o.customer_status = 'New customer' THEN 1 ELSE NULL END) * 1.0 / COUNT(o.customer_id)) * 100 AS share_of_new_customers,
  COUNT(DISTINCT item_quantity_low_in_stock) AS nb_of_items_low_in_stock,
  stk.store_name AS store_name,
  stk.store_city AS store_city
FROM {{ ref("int_local_bike__orders") }} AS o
LEFT JOIN {{ ref("int_local_bike__stocks") }} AS stk ON stk.store_id = o.store_id
-- I'm limiting myself to this date because the data is patchy after that
-- would not be done in a normal env.
WHERE o.order_date <= '2018-04-30' 
GROUP BY 
  report_date,
  stk.store_name,
  stk.store_city