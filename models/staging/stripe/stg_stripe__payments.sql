WITH source AS
    (SELECT *
       FROM {{ source('stripe', 'payments') }}
    )

   , transform AS
    (SELECT id                                  AS payment_id
          , orderid                             AS order_id
          , status                              AS payment_status
          , paymentmethod                       AS payment_method
          , {{ cents_to_dollars("amount") }}    AS payment_amount
          , created                             AS payment_date
       FROM source
    )

SELECT *
  FROM transform