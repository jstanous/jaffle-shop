{{ config(materialized='ephemeral') }}

WITH orders AS
    (SELECT * 
       FROM {{ ref('stg_jaffle_shop__orders') }}
    )

   , orders_stats AS
    (SELECT customer_id
          , MIN(order_date) AS first_order_date
          , MAX(order_date) AS last_order_date
          , COUNT(order_id) AS number_of_orders
       FROM orders
      GROUP BY 1
    )

SELECT *
  FROM orders_stats