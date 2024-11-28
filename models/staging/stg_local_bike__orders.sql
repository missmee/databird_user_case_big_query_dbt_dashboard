SELECT order_id,
  customer_id,
  CASE 
  WHEN order_status = 1 then 'Processed' 
  WHEN order_status = 2 then 'Shipped'
  WHEN order_status = 3 then 'Returned / Lost'
  WHEN order_status = 4 then 'Delivered'
  ELSE 'Unknown' 
  END AS order_status,
  order_date,
  store_id
FROM {{ source("local_bike", "orders") }}