-- version: 2
with customers as
    (select
         customer_id,
         customer_name,
         first_order_date,
         last_order_date,
         number_of_orders,
         lifetime_sales,
         average_order_amount
       from
         {{ ref('int_customers') }}
    )

select
    customer_id,
    customer_name,
    first_order_date,
    last_order_date,
    number_of_orders,
    lifetime_sales,
    average_order_amount
  from
    customers