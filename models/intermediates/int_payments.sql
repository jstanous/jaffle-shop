WITH payments AS
    (SELECT * 
       FROM {{ ref('stg_stripe__payments') }}
    )

   , orders AS
    (SELECT * 
       FROM {{ ref('stg_jaffle_shop__orders') }}
    )

   , payments_successful AS
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
      WHERE payment_status = 'success'
        AND NOT payment_amount = 0
    )

SELECT *
  FROM payments_successful