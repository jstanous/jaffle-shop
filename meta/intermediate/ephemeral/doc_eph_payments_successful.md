{% docs model__eph_payments_successful %}  
Ephemeral model for successful, non-zero Stripe Payments for Jaffle Shop orders.  

** Grain: ** one record per successful payment transaction  
** Source: ** stg_stripe__payments, stg_jaffle_shop__orders  
{% enddocs %}  
