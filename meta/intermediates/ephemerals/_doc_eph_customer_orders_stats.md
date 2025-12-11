{% docs model__eph_customer_orders_stats %}  
Ephemeral model for Jaffle Shop customer order metrics.  

** Source: ** stg_jaffle_shop__orders  
** Grain: ** One record per customer.  
{% enddocs %}  

{% docs column__first_order_date %}  
Earliest order date for the customer.  

** Business Name: ** First Order Date  
** Use case: ** Identify customer's first order date for tenure. 
** Logic: ** MIN(order_date)  
{% enddocs %}  

{% docs column__last_order_date %}  
Latest order date for the customer.  

** Business Name: ** Last Order Date  
** Use case: ** Identify customer's most recent order.  
** Logic: ** MAX(order_date)  
{% enddocs %}  

{% docs column__number_of_orders %}  
Number of orders for the customer.  

** Business Name: ** Number of Orders  
** Use case: ** Identify number of orders for the customer.  
** Logic: ** COUNT(order_id)  
{% enddocs %}  
