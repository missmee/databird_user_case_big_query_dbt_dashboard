SELECT
  customer_id,
  city AS customer_city,
  CONCAT(street, " ", zip_code, " ", city, " ", state) AS customer_full_address,
FROM {{ source("local_bike", "customers") }} c