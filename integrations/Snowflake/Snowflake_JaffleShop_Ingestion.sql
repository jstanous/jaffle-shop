/*------------------------------------------------------------------------------
Script: Snowflake_JaffleShop_Ingestion.sql
Purpose:
  Load exemplar Jaffle Shop datasets from public S3 buckets into the RAW schema
  of the JAFFLE_SHOP database. This script provisions baseline data for dbt
  lessons and validates ingestion with simple SELECT queries.

Steps:
  1. Context Setup
     - Uses DBT_WH warehouse for execution.
     - Switches to JAFFLE_SHOP database and RAW schema.
     - Runs under DBT_ROLE to enforce least-privilege access.

  2. Data Ingestion
     - CUSTOMERS: loads customer CSV into RAW.CUSTOMERS.
     - ORDERS: loads order CSV into RAW.ORDERS.
     - PAYMENTS: loads Stripe payments CSV into RAW.PAYMENTS.
     - All COPY INTO commands use CSV file format with header skip.

  3. Validation
     - Executes SELECT queries against CUSTOMERS, ORDERS, and PAYMENTS.
     - Confirms successful ingestion and allows quick inspection of loaded records.

Governance Notes:
  - Ingestion runs under DBT_ROLE, not SYSADMIN, to demonstrate controlled access.
  - Public S3 bucket is used for exemplar data only; production ingestion
    should use secured storage integrations.
  - RAW schema separation ensures lineage clarity between raw loads,
    staging transformations, and downstream marts.

Usage:
  Designed for public exemplars and reusable in Snowflake to support dbt lesson integration.
------------------------------------------------------------------------------*/

-- 1. Context Setup
USE WAREHOUSE DBT_WH;
USE DATABASE JAFFLE_SHOP;
USE SCHEMA RAW;
USE ROLE DBT_ROLE;

-- 2. Data Ingestion
COPY INTO CUSTOMERS (ID, FIRST_NAME, LAST_NAME)
     FROM 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
     FILE_FORMAT =
         (TYPE = 'CSV'
          FIELD_DELIMITER = ','
          SKIP_HEADER = 1
         );

COPY INTO ORDERS (ID, USER_ID, ORDER_DATE, STATUS)
     FROM 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
     FILE_FORMAT =
         (TYPE = 'CSV'
          FIELD_DELIMITER = ','
          SKIP_HEADER = 1
         );

COPY INTO PAYMENTS (ID, ORDERID, PAYMENTMETHOD, STATUS, AMOUNT, CREATED)
     FROM 's3://dbt-tutorial-public/stripe_payments.csv'
     FILE_FORMAT =
         (TYPE = 'CSV'
          FIELD_DELIMITER = ','
          SKIP_HEADER = 1
         );


-- 3. Validation
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;
SELECT * FROM PAYMENTS;