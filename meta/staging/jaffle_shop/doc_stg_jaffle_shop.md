{% docs model__stg_jaffle_shop__customers %}
Staging model for Jaffle Shop customers  

** Grain: ** one record per customer  
** Source: ** jaffle_shop.raw.customers  
{% enddocs %}

{% docs column__customer_name %}
Customer Name - full name for the customer (source: customers.first_name, customers.last_name)
{% enddocs %}

{% docs model__stg_jaffle_shop__orders %}
Staging model for Jaffle Shop orders  

** Grain: ** one record per order  
** Source: ** jaffle_shop.raw.orders  
{% enddocs %}