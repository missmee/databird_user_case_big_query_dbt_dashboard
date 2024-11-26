{% docs int_local_bike__order_items %}

This model compiles a lot of information about order_items in each order.

Keys
- **order_item_it** the primary key
- **order_id** foreign key coming from the orders table
- **product_id**: Foreign key linking to each product in the product table
- **store_id**: Foreign key linking to each stores in the store table
- **Brand id**: Foreign key linking to each product's brand in the brand table

- **total_order_item_amount**: The total amount for this order item, calculated as (list_price * quantity) * (1 - discount) in the stg_local_bike__order_items model.
- **item_quantity**: Quantity of items ordered in each order
- **Brand name**: Brand names
- **Product_name**: Product names



{% enddocs %}
