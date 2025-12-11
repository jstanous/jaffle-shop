{{ config(materialized='ephemeral') }}

WITH payments AS
    (SELECT * 
       FROM {{ ref('eph_payments_successful') }}
     ORDER BY order_id, payment_id
    )

   , order_amounts AS
    (SELECT order_id
          , customer_id
          , SUM(payment_amount) AS order_amount
       FROM payments
      GROUP BY 1, 2)

   , orders_customer_running_sales AS
    (SELECT order_id
          , SUM(order_amount)
            OVER (PARTITION BY customer_id
                  ORDER BY order_id
                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                 ) AS customer_running_sales
       FROM order_amounts
    )

SELECT *
  FROM orders_customer_running_sales
 order by 1