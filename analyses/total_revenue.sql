select 
    sum(payment_amount) as total_revenue
  from
    {{ ref('stg_stripe__payments') }}
 where
    payment_status = 'success'
 