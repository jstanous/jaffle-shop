{% docs model__eph_customer_lifetime_sales %}  
Ephemeral model for Jaffle Shop customer lifetime sales.  

** Source: ** int_orders  
** Grain: ** One record per customer.  
{% enddocs %}  

{% docs column__lifetime_sales %}  
Total amount of orders for the customer.  

** Business Name: ** Customer Lifetime Sales
** Use case: ** Identify total orders by customer.  
** Logic: ** SUM(order_amount)
{% enddocs %}  
