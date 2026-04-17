{% docs model__eph_orders_paid %}
Ephemeral model for Jaffle Shop paid customer orders.  

** Grain: ** One record per order  
** Source: ** stg_jaffle_shop__orders, stg_stripe__payments  
{% enddocs %}

{% docs column__order_amount %}
Order Amount - amount for the order (logic: renames stg_stripe__payments.payment_amount)  
{% enddocs %}
