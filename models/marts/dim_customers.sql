WITH customers AS
    (SELECT *
       FROM {{ ref('int_customers') }}
    )

SELECT * 
  FROM customers