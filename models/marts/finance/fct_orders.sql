{{ config(
          materialized = 'incremental',
          unique_key = 'order_id',
          incremental_strategy = 'merge',
          on_schema_change = 'fail',
         ) }}

--          incremental_strategy = 'append',
--          incremental_strategy = 'merge',
--          incremental_strategy = 'delete+insert',   -- Used when Merge isn't supported
--          incremental_strategy = 'insert_override', -- Best for BigQuery -- Requires partition config block
--          incremental_strategy = 'microbatch',

--          on_schema_change = 'ignore',
--          on_schema_change = 'fail',
--          on_schema_change = 'append_new_columns',
--          on_schema_change = 'sync_all_columns',

WITH int_orders AS
    (SELECT *
       FROM {{ ref ('int_orders' )}}
    )

   , fct_orders AS 
    (SELECT order_id
          , customer_id
          , order_date
          , order_amount
--          , 'test' as fail_value -- this was used to force config "on_schema_change = 'fail',"
       FROM int_orders
    )

SELECT *
  FROM fct_orders
  {% if is_incremental() %}
  -- this filter will only be applied on an incremental run
  WHERE order_date
      > (SELECT MAX(order_date)
           FROM {{ this }}
        ) 
  {% endif %}
