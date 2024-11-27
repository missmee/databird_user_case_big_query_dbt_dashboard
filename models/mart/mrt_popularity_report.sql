WITH ranked_products AS (
    SELECT 
        store_id,
        favorite_product_id,
        favorite_brand_id,
        product_name,
        brand_name,
        ROW_NUMBER() OVER (
            PARTITION BY store_id 
            ORDER BY favorite_product_id DESC, favorite_brand_id DESC
        ) AS row_num -- Classement des lignes pour chaque magasin
    FROM {{ ref('int_local_bike__customer_favorites') }}
)
SELECT 
    store_id,
    favorite_product_id,
    favorite_brand_id,
    product_name,
    brand_name
FROM ranked_products
WHERE row_num <= 3 -- Top 3 pour chaque magasin