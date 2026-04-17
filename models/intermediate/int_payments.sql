WITH payments_successful AS
    (SELECT * 
       FROM {{ ref('eph_payments_successful') }}
    )

SELECT *
  FROM payments_successful