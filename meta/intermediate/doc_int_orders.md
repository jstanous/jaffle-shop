{% docs model__int_orders %}  
Intermediate model for Jaffle Shop paid orders.  

** Grain: ** one record per paid order  
** Source: **  eph_orders_paid, eph_orders_sequences, eph_orders_customer_running_sales, stg_jaffle_shop__customers
{% enddocs %}  

{% docs column__customer_status %}  
Customer Status - indicates if the customer is new or returning at time of order (logic: CASE customer_order_seq WHEN 1 THEN 'new' ELSE 'return' END)  see customer_status seed for value definitions    
{% enddocs %}  



