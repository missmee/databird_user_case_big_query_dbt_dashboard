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
-- I'm limiting myself to this date because the data is patchy after that
-- would not be done in a normal env.
WHERE order_date <= '2018-04-30' 