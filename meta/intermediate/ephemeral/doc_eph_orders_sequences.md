{% docs model__eph_orders_sequences %}
Ephemeral model for Jaffle Shop customer orders sequences.  

** Grain: ** one record per order  
** Source: ** stg_jaffle_shop__orders  
{% enddocs %}

{% docs column__order_seq %}
Order Sequence - sequence identifier of order in all orders (logic: ROW_NUMBER() OVER (ORDER BY order_id))  
{% enddocs %}

{% docs column__customer_order_seq %}
Customer Order Sequence - sequence identifier of order in all customer orders (logic: ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_id))  
{% enddocs %}