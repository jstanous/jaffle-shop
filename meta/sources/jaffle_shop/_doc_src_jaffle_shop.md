{% docs source__jaffle_shop %}  
Clone of the original Postgres jaffle_shop database.  
Files from dbt Fundamentals course.  
{% enddocs %}  

{% docs table__customers %}  
This is the raw Customer data.  

** Source: ** jaffle_shop.raw.customers  
** Grain: ** One record per customer.  
{% enddocs %}  

{% docs column__customer_id %}  
Unique identifier for the customer.  

** Business Name: ** Customer Id  
** Source: ** customers.id  

** Role: ** 
 - Primary Key  
 - Foreign Key for orders.  
{% enddocs %}  

{% docs column__customer_first_name %}  
First name of the customer.  

** Business Name: ** Customer First Name  
** Source: ** customers.first_name  
{% enddocs %}  

{% docs column__customer_last_name %}  
Last name of the customer.  

** Business Name: ** Customer Last Name  
** Source: ** customers.last_name  
{% enddocs %}  

{% docs table__orders %}  
This is the raw Orders data.  

** Source: ** jaffle_shop.raw.orders 
** Grain: **
 - One record per order.  
 - Customers may have multiple orders.

{% enddocs %}  

{% docs column__order_id %}  
Unique identifier for the order.  

** Business Name: ** Order Id  
** Source: ** orders.id  
** Role: **
 - Primary Key
 - Foreign Key for payments.  
{% enddocs %}

{% docs column__order_date %}
Date of the order.  

** Business Name: ** Order Date  
** Source: ** orders.order_date  
{% enddocs %}  

{% docs column__order_status %}  
Status of the order.  

** Business Name: ** Order Status  
** Source: ** orders.status  

** Values: **  
 - placed — Order placed, not yet shipped  
 - shipped — Order has been shipped, not yet been delivered  
 - completed — Order has been received by customers  
 - return pending — Customer indicated they want to return this item  
 - returned — Item has been returned  
{% enddocs %}  
