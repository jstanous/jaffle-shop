{% docs model__int_orders %}  
Intermediate model for Jaffle Shop orders.  

** Source: **  
 - stg_jaffle_shop__orders  
 - eph_orders_paid  
 - eph_orders_sequences  
 - eph_orders_customer_running_sales  
** Grain: ** One record per order.  
{% enddocs %}  

{% docs column__customer_order_status %}  
Indicates if the customer is new or returning at time of orders  

** Business Name: ** Customer Order Status  
** Source: ** eph_orders_sequences  

** Use case: ** Indicate if customer is new or returning  
** Values: **  
 - new — first order for new customer.  
 - returning — returning customer with multiple orders.  

** Logic: ** CASE customer_order_seq WHEN 1 THEN 'new' ELSE 'return' END  
{% enddocs %}  
