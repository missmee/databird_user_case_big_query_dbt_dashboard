SELECT product_id,
product_name,
brand_id,
category_id,
model_year,
list_price AS item_price
FROM {{ source("local_bike", "products") }}