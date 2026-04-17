{% docs model__eph_customer_orders_stats %}
Ephemeral model for Jaffle Shop customer order metrics.  

** Grain: ** one record per customer.  
** Source: ** eph_orders_paid  
{% enddocs %}

{% docs column__first_order_date %}
First Order Date - earliest order date for the customer (logic: MIN(order_date))  
{% enddocs %}

{% docs column__last_order_date %}
Last Order Date - Latest order date for the customer (logic: MAX(order_date))  
{% enddocs %}

{% docs column__number_of_orders %}  
Number of Orders - total number of orders for the customer (logic: COUNT(order_id))  
{% enddocs %}  

{% docs column__lifetime_sales %}  
Customer Lifetime Sales - total amount of orders for the customer (logic: sum(order_amount))
{% enddocs %}  

{% docs column__average_order_amount %}  
Customer Average Order Amount - average amount of orders for the customer (logic: lifetime_sales/number_of_orders)
{% enddocs %}  
