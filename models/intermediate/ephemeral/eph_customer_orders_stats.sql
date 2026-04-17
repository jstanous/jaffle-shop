WITH orders AS
    (SELECT order_id
          , customer_id
          , order_date
          , order_status
          , payment_date
          , order_amount
       FROM {{ ref('eph_orders_paid') }}
    )

   , orders_stats AS
    (SELECT customer_id
          , MIN(order_date) AS first_order_date
          , MAX(order_date) AS last_order_date
          , COUNT(DISTINCT order_id) AS number_of_orders
          , SUM(order_amount) AS lifetime_sales
          , lifetime_sales/number_of_orders AS average_order_amount
       FROM orders
      GROUP BY 1
    )

SELECT customer_id
     , first_order_date
     , last_order_date
     , number_of_orders
     , lifetime_sales
     , average_order_amount
  FROM orders_stats