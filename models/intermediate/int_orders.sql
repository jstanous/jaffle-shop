
WITH orders_paid AS
    (SELECT order_id
          , customer_id
          , order_date
          , order_status
          , order_amount
          , payment_date
       FROM {{ ref('eph_orders_paid') }}
    )

   , orders_seq AS
    (SELECT order_id
          , order_seq
          , customer_order_seq
       FROM {{ ref('eph_orders_sequences') }}
    )

   , orders_customer_running_sales AS
    (SELECT order_id
          , customer_running_sales
       FROM {{ ref('eph_orders_customer_running_sales')}}
    )

   , customers AS
    (SELECT customer_id
          , customer_name
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
             END AS customer_status
          , orders_customer_running_sales.customer_running_sales
       FROM orders_paid
       JOIN orders_seq
            USING (order_id)
       JOIN orders_customer_running_sales
            USING (order_id)
       JOIN customers
            USING (customer_id)
    )

SELECT order_id
     , customer_id
     , customer_name
     , order_date
     , order_status
     , order_amount
     , payment_date
     , order_seq
     , customer_order_seq
     , customer_status
     , customer_running_sales
  FROM orders