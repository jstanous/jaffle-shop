{% docs model__int_payments_failed %}  
Intermediate model for failed, non-zero Stripe Payment transactions.  

** Source: **  
 - stg_stripe__payments  
 - stg_jaffle_shop__orders  
** Grain: ** One record per failed payment transaction.  
{% enddocs %}  
