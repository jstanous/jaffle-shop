{% docs source__stripe %}
Clone of the original Stripe payments data.  
Files from dbt Fundamentals course.  
{% enddocs %}

{% docs table__payments %}
This is the raw payments data.  

** Grain: ** one record per payment transaction.  
** Source: ** jaffle_shop.raw.payments  
{% enddocs %}

{% docs column__payment_id %}
Payment Id - unique identifier for payment transaction (source: payments.id)  
{% enddocs %}

{% docs column__payment_method %}
Payment Method - the method used for the payment transaction (source: payments.paymentmethod) see payment_method seed for value definitions  
{% enddocs %}

{% docs column__payment_status %}
Payment Status - the status of the payment transaction (source: payments.status) see payment_status seed for value definitions  
{% enddocs %}

{% docs column__payment_amount %}
Payment Amount - the total amount of the payment transaction in USD (source: payments.amount) captured as cents (100 = $1.00), converted with macro(cents_to_dollars)  
{% enddocs %}

{% docs column__payment_date %}
Payment Date - the date of the payment transaction (source: payments.created)  
{% enddocs %}