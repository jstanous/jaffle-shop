WITH customers AS
    (SELECT *
       FROM {{ ref('stg_jaffle_shop__customers') }}
    )

   , customer_orders_stats AS
    (SELECT *
       FROM {{ ref('eph_customer_orders_stats') }}
    )

   , customer_lts AS
    (SELECT *
       FROM {{ ref('eph_customer_lifetime_sales') }}
    )

   , final as
    (SELECT customers.customer_id
          , customers.customer_name
          , customer_orders_stats.first_order_date
          , customer_orders_stats.last_order_date
          , COALESCE(customer_orders_stats.number_of_orders, 0) AS number_of_orders
          , COALESCE(customer_lts.lifetime_sales, 0)            AS lifetime_sales
       FROM customers
       LEFT JOIN customer_orders_stats 
            USING (customer_id)
       LEFT JOIN customer_lts
            USING (customer_id)
    )

SELECT * 
  FROM final