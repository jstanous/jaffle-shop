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
          , payments.payment_amount as order_amount
          , payments.payment_date
       FROM orders
       JOIN payments
            USING(order_id)
    )

SELECT *
  FROM orders_paid
