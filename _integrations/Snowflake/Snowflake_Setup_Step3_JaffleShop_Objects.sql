/*------------------------------------------------------------------------------
Script: Snowflake_Setup_Step3_JaffleShop_Objects.sql

Purpose:
  Provision dedicated Snowflake objects for the Jaffle Shop project.
  This script creates databases, schemas, and raw data tables for development,
  qa, and production environments as required.

Sections:
  - Uses SYSADMIN role and JAFFLE_SHOP_WH warehouse for object creation.
  Database Setup
    - Creates JAFFLE_SHOP_DEV, JAFFLE_SHOP_QA, and JAFFLE_SHOP (Production) databases.
    - Drops JAFFLE_SHOP.PUBLIC schema from all databases enforce explicit schema usage.
  Schema Setup
    - Creates lesson-specific schemas in JAFFLE_SHOP and JAFFLE_SHOP_QA:
      RAW (raw data loads - Only created in JAFFLE_SHOP production database),
      REF (seeds data loads),
      STAGING (staging models),
      INTERMEDIATE (intermediate models),
      MARTS (marts models).
      MARTS_FINANCE (finance-domain marts models)
      DBT_PROJ_EVAL (Project Evaluator Package artifacts - QA Only)
    - Each schema includes comments clarifying its purpose.
  Raw Data Table Setup
    - Creates tables in JAFFLE_SHOP production database RAW schema.
    - RAW data tables are only created in production.
    - CUSTOMERS: baseline customer data with ETL timestamp.
    - ORDERS: order records with status and ETL timestamp.
    - PAYMENTS: Stripe payment records with method, status, amount, and ETL timestamp.
    - All tables include comments to clarify purpose and support lineage tracking.

Governance Notes:
  - PUBLIC schemas are dropped to avoid uncontrolled access.
  - Raw tables are provisioned with ETL timestamps for lineage and auditability.

Usage:
  Designed for public exemplars and reusable in Snowflake to support dbt lesson integration.
------------------------------------------------------------------------------*/
USE ROLE SYSADMIN;
USE WAREHOUSE JAFFLE_SHOP_WH;
----------------------------------
--     Database Setup           --
----------------------------------
--  Development (DEV)  --
CREATE DATABASE IF NOT EXISTS JAFFLE_SHOP_DEV
       COMMENT = 'Dedicated development database for Jaffle Shop project';
DROP SCHEMA IF EXISTS JAFFLE_SHOP_DEV.PUBLIC;
--  Quality Assurance (QA)  --
CREATE DATABASE IF NOT EXISTS JAFFLE_SHOP_QA
       COMMENT = 'Dedicated QA database for Jaffle Shop project';
DROP SCHEMA IF EXISTS JAFFLE_SHOP_QA.PUBLIC;
--  Production (PROD)  --
CREATE DATABASE IF NOT EXISTS JAFFLE_SHOP
       COMMENT = 'Dedicated Production database for Jaffle Shop project';
DROP SCHEMA IF EXISTS JAFFLE_SHOP.PUBLIC;

----------------------------------
--     Schema Setup             --
----------------------------------
--  Quality Assurance (QA)  --
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP_QA.DBT_PROJ_EVAL
       COMMENT = 'Schema for Jaffle Shop dbt_project_evaluator artifacts';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP_QA.REF
       COMMENT = 'Schema for Jaffle Shop seeds';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP_QA.STAGING
       COMMENT = 'Schema for Jaffle Shop staging models';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP_QA.INTERMEDIATE
       COMMENT = 'Schema for Jaffle Shop intermediate models';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP_QA.MARTS
       COMMENT = 'Schema for Jaffle Shop marts models';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP_QA.MARTS_FINANCE
       COMMENT = 'Schema for Jaffle Shop marts models';
--  Production (PROD)  --
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP.RAW
       COMMENT = 'Schema for Jaffle Shop raw data loads';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP.REF
       COMMENT = 'Schema for Jaffle Shop seeds';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP.STAGING
       COMMENT = 'Schema for Jaffle Shop staging models';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP.INTERMEDIATE
       COMMENT = 'Schema for Jaffle Shop intermediate models';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP.MARTS
       COMMENT = 'Schema for Jaffle Shop marts models';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP.MARTS_FINANCE
       COMMENT = 'Schema for Jaffle Shop marts models';
CREATE SCHEMA IF NOT EXISTS JAFFLE_SHOP.SNAPSHOTS
       COMMENT = 'Schema for Jaffle Shop Snapshots';

----------------------------------
--     Raw Data Table Setup     --
----------------------------------
CREATE TABLE IF NOT EXISTS JAFFLE_SHOP.RAW.CUSTOMERS
      (ID INTEGER
      ,FIRST_NAME VARCHAR
      ,LAST_NAME VARCHAR
      ,_ETL_LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      COMMENT = 'Table for Jaffle Shop raw customer data';

CREATE TABLE IF NOT EXISTS JAFFLE_SHOP.RAW.ORDERS
      (ID INTEGER
      ,USER_ID INTEGER
      ,ORDER_DATE DATE
      ,STATUS VARCHAR
      ,_ETL_LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      COMMENT = 'Table for Jaffle Shop raw orders data';

CREATE TABLE IF NOT EXISTS JAFFLE_SHOP.RAW.PAYMENTS
      (ID INTEGER
      ,ORDERID INTEGER
      ,PAYMENTMETHOD VARCHAR
      ,STATUS VARCHAR
      ,AMOUNT INTEGER
      ,CREATED DATE
      ,_ETL_LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      COMMENT = 'Table for Jaffle Shop raw Stripe Payments data';
