{% docs model__eph_payments_failed %}  
Intermediate model for failed, non-zero Stripe Payment transactions.  

** Grain: ** one record per failed payment transaction  
** Source: ** stg_stripe__payments, stg_jaffle_shop__orders  
{% enddocs %}  
