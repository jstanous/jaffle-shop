
{% docs source__stripe %}  
Clone of the original Stripe payments data.  
Files from dbt Fundamentals course.  
{% enddocs %}  

{% docs table__payments %}  
This is the raw payments data.  

** Grain: ** One record per payment transaction.  
** Source: ** jaffle_shop.raw.payments  
{% enddocs %}  

{% docs column__payment_id %}  
Unique identifier for payment transaction.  

** Business Name: ** Payment Id  
** Source: ** payments.id  

** Role: **  Primary Key  
{% enddocs %}  

{% docs column__payment_method %}
The method used for the payment transaction.  

** Business Name: ** Payment Method  
** Source: ** payments.paymentmethod  

** Values: **  
 - credit_card — Standard card payment  
 - bank_transfer — Transfer through bank account  
 - gift_card — Store-issued gift card  
 - coupon — Promotional coupon  
{% enddocs %}

{% docs column__payment_status %}  
The status of the payment transaction.  

** Business Name: ** Payment Status  
** Source: ** payments.status  

** Values: **  
 - success — Payment transaction completed successfully  
 - fail — Payment transaction failed   
{% enddocs %}  

{% docs column__payment_amount %}  
The total amount of the payment transaction in USD.  
Captured as cents (e.g. 100 = $1.00).  

** Business Name: ** Payment Amount  
** Source: ** payments.amount  

** Logic: ** Jinja Macro - cents_to_dollars("amount")  
{% enddocs %}  

{% docs column__payment_date %}  
The date of the payment transaction.  

** Business Name: ** Payment Date  
** Source: ** payments.created  
{% enddocs %}  
