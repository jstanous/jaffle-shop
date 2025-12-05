WITH int_orders AS
    (SELECT *
       FROM {{ ref ('int_orders' )}}
    )

   , fct_orders AS 
    (SELECT order_id
          , customer_id
          , order_date
          , order_amount
       FROM int_orders
    )

SELECT *
  FROM fct_orders
