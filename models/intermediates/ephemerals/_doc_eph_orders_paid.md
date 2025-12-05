{% docs model__eph_orders_paid %}  
Ephemeral model for Jaffle Shop paid customer orders.  

** Source: **  
 - stg_jaffle_shop__orders  
 - stg_stripe__payments  
** Grain: ** One record per order.  
{% enddocs %}  

{% docs column__order_amount %}  
Amount for the order.  

** Business Name: ** Order Amount  
** Use case: ** Identify the amount of the order.  
** Logic: **  renames stg_stripe__payments.payment_amount  
{% enddocs %}  
