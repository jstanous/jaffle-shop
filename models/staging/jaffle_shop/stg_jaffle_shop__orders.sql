WITH source AS
    (SELECT *
       FROM {{ source('jaffle_shop', 'orders') }}
    )

   , transform AS
    (SELECT id          AS order_id
          , user_id     AS customer_id
          , order_date
          , status      AS order_status
       FROM source
    )

SELECT *
  FROM transform