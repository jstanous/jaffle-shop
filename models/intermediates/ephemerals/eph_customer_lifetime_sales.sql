{{ config(materialized='ephemeral') }}

WITH payments AS
    (SELECT * 
       FROM {{ ref('eph_payments_successful') }}
    )

   , customer_lts AS
    (SELECT customer_id
          , sum(payment_amount) AS lifetime_sales
       FROM payments
      GROUP BY 1
    )

SELECT *
  FROM customer_lts