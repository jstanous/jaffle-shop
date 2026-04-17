-- version: 1
WITH customers AS
    (SELECT
         customer_id,
         customer_name,
         first_order_date,
         last_order_date,
         number_of_orders,
         lifetime_sales
       FROM
         {{ ref('int_customers') }}
    )

SELECT
    customer_id,
    customer_name,
    first_order_date,
    last_order_date,
    number_of_orders,
    lifetime_sales
  FROM
    customers
