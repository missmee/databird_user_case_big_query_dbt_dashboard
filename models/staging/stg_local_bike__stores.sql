SELECT
  store_id,
  store_name,
  city AS store_city
FROM {{ source("local_bike", "stores") }}
