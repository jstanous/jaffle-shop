WITH source AS
    (SELECT *
       FROM {{source('jaffle_shop', 'customers') }}
    )

   , transform AS
    (SELECT id                           AS customer_id
          , first_name                   AS customer_first_name
          , last_name                    AS customer_last_name
          , first_name ||' '|| last_name AS customer_name
       FROM source
    )

SELECT *
  FROM transform