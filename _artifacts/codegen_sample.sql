{{ codegen.generate_source(schema_name= 'jaffle_shop', database_name= 'dbt_raw') }}
{{ codegen.generate_source(schema_name= 'stripe', database_name= 'dbt_raw') }}

{{ codegen.generate_base_model(source_name='jaffle_shop', table_name='customers', materialized='view') }}

dbt run-operation generate_model_yaml --args '{"model_names": ["fct_customer_orders"]}'
dbt run-operation generate_model_yaml args '{"model_names": ["fct_customer_orders"]}'
dbt run-operation generate_model_yaml --args '{"model_names": ["int_customers"]}'