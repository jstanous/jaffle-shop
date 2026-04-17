WITH customers AS
    (SELECT customer_id
          , customer_name
       FROM {{ ref('stg_jaffle_shop__customers') }}
    )

   , customer_orders_stats AS
    (SELECT customer_id
          , first_order_date
          , last_order_date
          , number_of_orders
          , lifetime_sales
          , average_order_amount
       FROM {{ ref('eph_customer_orders_stats') }}
    )

   , final as
    (SELECT customers.customer_id
          , customers.customer_name
          , customer_orders_stats.first_order_date
          , customer_orders_stats.last_order_date
          , COALESCE(customer_orders_stats.number_of_orders, 0)     AS number_of_orders
          , COALESCE(customer_orders_stats.lifetime_sales, 0)       AS lifetime_sales
          , COALESCE(customer_orders_stats.average_order_amount, 0) AS average_order_amount
       FROM customers
       LEFT JOIN customer_orders_stats 
            USING (customer_id)
    )

SELECT customer_id
     , customer_name
     , first_order_date
     , last_order_date
     , number_of_orders
     , lifetime_sales
     , average_order_amount
  FROM final