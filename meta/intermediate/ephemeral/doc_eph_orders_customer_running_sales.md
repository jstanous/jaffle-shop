{% docs model__eph_orders_customer_running_sales %}
Ephemeral model for Jaffle Shop running customer sales.  

** Grain: ** one record per order.  
** Source: ** int_payments  
{% enddocs %}

{% docs column__customer_running_sales %}
Customer Running Sales - customer sales to date including current order (logic: SUM(payment_amount) OVER (PARTITION BY customer_id ORDER BY order_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW))  
{% enddocs %}