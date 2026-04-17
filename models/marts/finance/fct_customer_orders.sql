WITH orders AS
    (SELECT order_id
          , customer_id
          , customer_name
          , customer_status
          , order_date
          , order_status
          , order_amount
          , payment_date
          , order_seq
          , customer_order_seq
          , customer_running_sales
       FROM {{ ref('int_orders') }}
    )

   , customers AS
    (SELECT customer_id
          , first_order_date
       FROM {{ ref('int_customers') }}
    )

   , customer_orders AS 
    (SELECT orders.order_id
          , orders.customer_id
          , orders.customer_name
          , orders.customer_status
          , orders.order_date
          , orders.order_status
          , orders.order_amount
          , orders.payment_date
          , orders.order_seq
          , orders.customer_order_seq
          , orders.customer_running_sales
          , customers.first_order_date
       FROM orders
       JOIN customers
            USING (customer_id)
    )

SELECT order_id
     , customer_id
     , customer_name
     , customer_status
     , order_date
     , order_status
     , order_amount
     , payment_date
     , order_seq
     , customer_order_seq
     , customer_running_sales
     , first_order_date
  FROM customer_orders
