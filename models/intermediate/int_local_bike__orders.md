{% docs int_local_bike__orders %}

This model provides an aggregated view of orders, combining data from multiple sources such as order items and customers. It enriches the order data with the following metrics:
- **Order_id**: The primary key

- **Total Order Amount**: The sum of all order items for each order.
- **Total Items**: The total quantity of items in the order.
- **Total Distinct Items**: The count of distinct product types in the order.
- **Customer_status**: Evaluates whever the customer is a new customer, a customer who ordered more than a month ago but ordered only once or
if it's a reccurent customer who ordered more than once.

The basic order data is order_status, order_date and store_id.

It provides a comprehensive view of each order, allowing for easy analysis of order performance, customer dynamics, and store evaluation.


{% enddocs %}
