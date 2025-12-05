WITH orders AS
    (SELECT *
       FROM {{ ref('int_orders') }}
    )

   , customers AS
    (SELECT *
       FROM {{ ref('int_customers') }}
    )

   , customer_orders AS 
    (SELECT orders.*
          , customers.first_order_date
       FROM orders
       JOIN customers
            USING (customer_id)
    )

SELECT *
  FROM customer_orders
