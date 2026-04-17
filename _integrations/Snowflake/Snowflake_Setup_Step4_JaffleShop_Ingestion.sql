/*------------------------------------------------------------------------------
Script: Snowflake_Setup_Step4_JaffleShop_Ingestion.sql

Purpose:
  Load exemplar Jaffle Shop datasets from public S3 buckets into the RAW schema
  of the JAFFLE_SHOP production database. This script provisions baseline source
  data for dbt lessons and validates ingestion through simple record inspection.

Sections:
  Uses SYSADMIN role and JAFFLE_SHOP_WH warehouse for all ingestion operations.

  Context Setup
  - Switches to JAFFLE_SHOP_WH warehouse.
  - Sets active database to JAFFLE_SHOP and schema to RAW.
  - Ensures ingestion occurs in the governed RAW layer.

  Data Ingestion
  - CUSTOMERS: loads customer CSV into RAW.CUSTOMERS.
  - ORDERS: loads order CSV into RAW.ORDERS.
  - PAYMENTS: loads Stripe payments CSV into RAW.PAYMENTS.
  - All COPY INTO commands use CSV format with header skipping and explicit
    column lists to support schema clarity and reproducibility.

  Validation
  - Executes SELECT queries against CUSTOMERS, ORDERS, and PAYMENTS.
  - Confirms successful ingestion and provides quick visibility into loaded
    records for lesson readiness.

Governance Notes:
  - Ingestion is executed under SYSADMIN to maintain clear separation between
    object creation privileges and downstream modeling roles.
  - Public S3 buckets are used only for exemplar data; production ingestion
    should rely on secure storage integrations and governed pipelines.
  - RAW schema isolation preserves lineage, auditability, and controlled
    handoff into STAGING and downstream transformation layers.

Usage:
  Designed for public exemplars and reusable in Snowflake to support dbt lesson
  integration and consistent ingestion patterns across environments.
------------------------------------------------------------------------------*/

-----------------------------
--     Context Setup       --
-----------------------------
USE WAREHOUSE JAFFLE_SHOP_WH;
USE DATABASE JAFFLE_SHOP;
USE SCHEMA RAW;
USE ROLE SYSADMIN;

-----------------------------
--     Data Ingestion      --
-----------------------------
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


-----------------------------
--     Data Validation     --
-----------------------------
SELECT * FROM CUSTOMERS LIMIT 10;
SELECT * FROM ORDERS LIMIT 10;
SELECT * FROM PAYMENTS LIMIT 10;