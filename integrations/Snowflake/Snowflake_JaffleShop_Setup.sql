/*------------------------------------------------------------------------------
Script: Snowflake_JaffleShop_Setup.sql
Purpose:
  Provision a modular Snowflake environment for dbt Jaffle Shop lessons.
  This script creates the JAFFLE_SHOP database, lesson-specific schemas,
  and raw exemplar tables to support hands-on modeling exercises.

Steps:
  1. Database & Schema Setup
     - Uses SYSADMIN role and DBT_WH warehouse for object creation.
     - Creates DBT.JAFFLE_SHOP schema for dbt internal artifacts.
     - Creates JAFFLE_SHOP database for production exemplars.
     - Drops JAFFLE_SHOP.PUBLIC schema to enforce explicit schema usage.

  2. Role & Privilege Grants
     - Uses SECURITYADMIN role for controlled privilege assignment.
     - Grants usage on JAFFLE_SHOP database to DBT_ROLE.
     - Grants usage and object creation rights on all future schemas in JAFFLE_SHOP.
     - Ensures dbt can create tables, views, stages, and file formats
       without manual re-granting.

  3. Production Schema Setup
     - Creates lesson-specific schemas in JAFFLE_SHOP:
       RAW (raw data loads),
       STAGING (staging models),
       INTERMEDIATES (intermediate models),
       MARTS (mart models).
     - Each schema includes comments clarifying its purpose.

  4. Raw Data Tables
     - CUSTOMERS: baseline customer data with ETL timestamp.
     - ORDERS: order records with status and ETL timestamp.
     - PAYMENTS: Stripe payment records with method, status, amount, and ETL timestamp.
     - All tables include comments to clarify purpose and support lineage tracking.

Governance Notes:
  - Role usage alternates between SYSADMIN (object creation) and SECURITYADMIN (grants),
    demonstrating least-privilege principles.
  - PUBLIC schemas are dropped to avoid uncontrolled access.
  - Raw tables are provisioned with ETL timestamps for lineage and auditability.

Usage:
  Designed for public exemplars and reusable in Snowflake to support dbt lesson integration.
------------------------------------------------------------------------------*/

-- 1. Database & Schema Setup
USE ROLE SYSADMIN;
USE WAREHOUSE DBT_WH;

CREATE SCHEMA IF NOT EXISTS DBT_DB.JAFFLE_SHOP
       COMMENT = 'Dedicated schema for dbt internal artifacts for jaffle-shop project';

CREATE DATABASE IF NOT EXISTS JAFFLE_SHOP
       COMMENT = 'Dedicated database for production artifacts jaffle-shop project';
DROP SCHEMA IF EXISTS JAFFLE_SHOP.PUBLIC;

--2. Role & Privilege Grants
USE ROLE SECURITYADMIN;
GRANT USAGE ON DATABASE JAFFLE_SHOP TO ROLE DBT_ROLE;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE JAFFLE_SHOP TO ROLE DBT_ROLE;
GRANT CREATE TABLE
     ,CREATE VIEW
     ,CREATE STAGE
     ,CREATE FILE FORMAT
   ON FUTURE SCHEMAS IN DATABASE JAFFLE_SHOP
   TO DBT_ROLE;


-- 3. Production Schema Setup
USE ROLE SYSADMIN;
USE DATABASE JAFFLE_SHOP;
CREATE SCHEMA IF NOT EXISTS RAW
       COMMENT = 'Schema for Jaffle Shop raw data loads';

CREATE SCHEMA IF NOT EXISTS STAGING
       COMMENT = 'Schema for Jaffle Shop staging models';

CREATE SCHEMA IF NOT EXISTS INTERMEDIATES
       COMMENT = 'Schema for Jaffle Shop intermediate models';

CREATE SCHEMA IF NOT EXISTS MARTS
       COMMENT = 'Schema for Jaffle Shop marts models';

-- 4. Raw Data Tables
USE SCHEMA RAW;
CREATE TABLE IF NOT EXISTS CUSTOMERS
      (ID INTEGER
      ,FIRST_NAME VARCHAR
      ,LAST_NAME VARCHAR
      ,_ETL_LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      COMMENT = 'Table for Jaffle Shop raw customer data';

CREATE TABLE IF NOT EXISTS ORDERS
      (ID INTEGER
      ,USER_ID INTEGER
      ,ORDER_DATE DATE
      ,STATUS VARCHAR
      ,_ETL_LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      COMMENT = 'Table for Jaffle Shop raw orders data';

CREATE TABLE IF NOT EXISTS PAYMENTS
      (ID INTEGER
      ,ORDERID INTEGER
      ,PAYMENTMETHOD VARCHAR
      ,STATUS VARCHAR
      ,AMOUNT INTEGER
      ,CREATED DATE
      ,_ETL_LOADED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      COMMENT = 'Table for Jaffle Shop raw Stripe Payments data';
