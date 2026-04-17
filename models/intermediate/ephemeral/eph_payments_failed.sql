WITH payments AS
    (SELECT payment_id
          , order_id
          , payment_date
          , payment_status
          , payment_method
          , payment_amount
       FROM {{ ref('stg_stripe__payments') }}
    )

   , orders AS
    (SELECT order_id
          , customer_id
       FROM {{ ref('stg_jaffle_shop__orders') }}
    )

   , payments_failed AS
    (SELECT payments.payment_id
          , orders.customer_id
          , payments.order_id
          , payments.payment_date
          , payments.payment_status
          , payments.payment_method
          , payments.payment_amount
       FROM payments
       JOIN orders
            USING (order_id)
      WHERE payment_status = 'fail'
        AND NOT payment_amount = 0
    )

SELECT payment_id
     , customer_id
     , order_id
     , payment_date
     , payment_status
     , payment_method
     , payment_amount
  FROM payments_failed
