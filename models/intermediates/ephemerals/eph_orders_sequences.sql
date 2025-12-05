{{ config(materialized='ephemeral') }}

WITH orders AS
    (SELECT * 
       FROM {{ ref('stg_jaffle_shop__orders') }}
    )

   , orders_sequences AS
    (SELECT orders.order_id
          , ROW_NUMBER() OVER (ORDER BY orders.order_id) as order_seq
          , ROW_NUMBER() OVER (PARTITION BY orders.customer_id ORDER BY orders.order_id) as customer_order_seq
       FROM orders
    )

SELECT *
  FROM orders_sequences