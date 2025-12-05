{% docs model__eph_orders_customer_running_sales %}  
Ephemeral model for Jaffle Shop running customer sales.  

** Source: ** int_payments  
** Grain: ** One record per order.  
{% enddocs %}  

{% docs column__customer_running_sales %}  
Customer sales to date including current order.  

** Business Name: ** Customer Running Sales  
** Use case: ** Identify total customer sales as of latest order.  
** Logic: ** SUM(payment_amount) OVER (PARTITION BY customer_id ORDER BY order_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  
{% enddocs %}  
