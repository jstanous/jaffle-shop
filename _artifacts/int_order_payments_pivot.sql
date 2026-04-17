
with payments as
    (select *
       from {{ ref('stg_stripe__payments') }}
      where payment_status = 'success')
   , payment_types as 
    (select payment_method as payment_type
       from payments
      group by 1)
   , payments_pivot as
    (select order_id
            {%- set payment_methods = ['bank_transfer', 'coupon', 'credit_card', 'gift_card'] -%}
            {% for payment_method in payment_methods %}
          , sum(case when payment_method = '{{ payment_method }}' then payment_amount end) as {{payment_method}}_amount 
            {% endfor %}
       from payments
      group by 1)
select *
  from payments_pivot