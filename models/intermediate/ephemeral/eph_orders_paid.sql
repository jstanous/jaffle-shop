WITH orders AS
    (SELECT order_id
          , customer_id
          , order_date
          , order_status
       FROM {{ ref('stg_jaffle_shop__orders') }}
    )

   , payments AS
    (SELECT order_id
          , payment_date
          , payment_amount
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

SELECT order_id
     , customer_id
     , order_date
     , order_status
     , payment_date
     , order_amount
  FROM orders_paid