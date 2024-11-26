WITH product_low_in_stock AS (
  SELECT product_id,
  item_quantity_in_stock AS item_quantity_low_in_stock
  FROM {{ ref("stg_local_bike__stocks") }}
  WHERE item_quantity_in_stock < 2
)

SELECT
  stk.product_id,
  p.category_id,
  p.product_name, 
  c.category_name,
  pntk.item_quantity_low_in_stock,
  st.store_name,
  st.store_city,
  st.store_id
FROM product_low_in_stock AS pntk
LEFT JOIN {{ ref("stg_local_bike__stocks") }} AS stk ON pntk.product_id = stk.product_id
LEFT JOIN {{ ref("stg_local_bike__products") }} AS p ON stk.product_id = p.product_id
LEFT JOIN {{ ref("stg_local_bike__categories") }} AS c ON p.category_id = c.category_id
LEFT JOIN {{ ref("stg_local_bike__stores") }} AS st ON stk.store_id = st.store_id