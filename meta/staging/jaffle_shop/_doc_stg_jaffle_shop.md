{% docs model__stg_jaffle_shop__customers %}  
Staging model for Jaffle Shop customers.  

** Source: ** jaffle_shop.raw.customers  
** Grain: ** One record per customer.  
{% enddocs %}  

{% docs column__customer_name %}  
Full name for the customer.  

** Business Name: ** Customer Name  
** Source: **  
 - customers.first_name  
 - customers.last_name  

** Use case: ** Provide customer's full name.

** Logic: ** first_name ||' '|| last_name
{% enddocs %}  

{% docs model__stg_jaffle_shop__orders %}  
Staging model for Jaffle Shop orders.  

** Source: ** jaffle_shop.raw.orders  
** Grain: **
 - One record per order.  
 - Customers may have multiple orders.
{% enddocs %}  
