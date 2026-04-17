{% docs source__jaffle_shop %}
Clone of the original Postgres jaffle_shop database.  
Files from dbt Fundamentals course.  
{% enddocs %}

{% docs table__customers %}
This is the raw customer data.  
  
** Grain: ** one record per customer  
** Source: ** jaffle_shop.raw.customers  
{% enddocs %}

{% docs column__customer_id %}
Customer Id - unique identifier for the customer (source: customers.id)  
{% enddocs %}

{% docs column__customer_first_name %}
Customer First Name - first name of the customer (source: customers.first_name)  
{% enddocs %}

{% docs column__customer_last_name %}
Customer Last Name - last name of the customer (source: customers.last_name)  
{% enddocs %}

{% docs table__orders %}
This is the raw orders data.  
  
** Grain: **  one record per order  
** Source: ** jaffle_shop.raw.orders  
{% enddocs %}

{% docs column__order_id %}
Order Id - unique identifier for the order (source: orders.id)  
{% enddocs %}

{% docs column__order_date %}
Order Date - date of the order (source: orders.order_date)  
{% enddocs %}

{% docs column__order_status %}
Order Status - status of the order (source: orders.status) see order_status seed for value definitions  
{% enddocs %}