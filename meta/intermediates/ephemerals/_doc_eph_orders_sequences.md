{% docs model__eph_orders_sequences %}  
Ephemeral model for Jaffle Shop customer orders sequences.  

** Source: ** stg_jaffle_shop__orders  
** Grain: ** One record per order.  
{% enddocs %}  

{% docs column__order_seq %}  
Sequence identifier of order in all orders.  

** Business Name: ** Order Sequence  
** Use case: ** Identify sequence of orders.  
** Logic: **  ROW_NUMBER() OVER (ORDER BY order_id)  
{% enddocs %}  

{% docs column__customer_order_seq %}  
Sequence identifier of order in all customer orders.  

** Business Name: ** Customer Order Sequence  
** Use case: ** Identify sequence of customer's orders.  
** Logic: **  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_id)  
{% enddocs %}  
