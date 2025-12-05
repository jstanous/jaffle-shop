
WITH orders_paid AS
    (SELECT * 
       FROM {{ ref('eph_orders_paid') }}
    )

   , orders_seq AS
    (SELECT * 
       FROM {{ ref('eph_orders_sequences') }}
    )

   , orders_customer_running_sales AS
    (SELECT *
      FROM {{ ref('eph_orders_customer_running_sales')}}
    )

   , customers AS
    (SELECT * 
       FROM {{ ref('stg_jaffle_shop__customers') }}
    )

   , orders AS
    (SELECT orders_paid.order_id
          , orders_paid.customer_id
          , customers.customer_name
          , orders_paid.order_date
          , orders_paid.order_status
          , orders_paid.order_amount
          , orders_paid.payment_date
          , orders_seq.order_seq
          , orders_seq.customer_order_seq
          , CASE orders_seq.customer_order_seq
                 WHEN 1
                      THEN 'new'
                 ELSE 'return'
             END AS customer_order_status
          , orders_customer_running_sales.customer_running_sales
       FROM orders_paid
       JOIN orders_seq
            USING (order_id)
       JOIN orders_customer_running_sales
            USING (order_id)
       JOIN customers
            USING (customer_id)
    )

SELECT *
  FROM orders