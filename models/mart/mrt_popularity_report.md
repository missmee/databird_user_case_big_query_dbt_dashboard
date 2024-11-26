{% docs mrt_popularity_report %}

This model provides a condensed view of the top 3 favorite products and brands of each store from past clients since ever. 
It is filtered on past client as a sign of a preference.

- **Store_id**: The primary key

- **Favorite product id**: The id of the mostly ordered products by past clients.
- **Favorite brand id**: The id of the mostly ordered products by past clients.
- **Favorite product name**: The count of distinct product types in the order.
- **Favorite brand name**: The name of the mostly ordered products by past clients.

{% enddocs %}