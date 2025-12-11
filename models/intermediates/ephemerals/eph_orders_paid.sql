{{ config(materialized='ephemeral') }}

WITH orders AS
    (SELECT * 
       FROM {{ ref('stg_jaffle_shop__orders') }}
    )

   , payments AS
    (SELECT * 
       FROM {{ ref('eph_payments_successful') }}
    )

   , orders_paid AS
    (SELECT orders.order_id
          , orders.customer_id
          , orders.order_date
          , orders.order_status
          , payments.payment_date
          , SUM(payments.payment_amount) as order_amount
       FROM orders
       JOIN payments
            USING(order_id)
      GROUP BY 1, 2, 3, 4, 5
    )

SELECT *
  FROM orders_paid