/*------------------------------------------------------------------------------
Script: Snowflake_Setup_Step5_JaffleShop_Grants.sql
Purpose:
  Apply least‑privilege GRANTs across Jaffle Shop environments to support dbt
  operations, development workflows, and governed read‑only access.

Sections:
  Uses SECURITYADMIN role for all GRANT operations.

  JAFFLE_SHOP_DBT_ROLE GRANTs
    - DEV Environment:
      - USAGE, MONITOR, and CREATE SCHEMA on JAFFLE_SHOP_DEV database.
      - CREATE TABLE, CREATE VIEW, and MODIFY on ALL and FUTURE schemas.
    - QA Environment:
      - USAGE and MONITOR on JAFFLE_SHOP_QA database.
      - USAGE, CREATE TABLE, CREATE VIEW, MODIFY on ALL schemas.
    - Production Environment:
      - USAGE and MONITOR on JAFFLE_SHOP database.
      - RAW schema: USAGE + SELECT on ALL and FUTURE tables.
      - REF, STAGING, INTERMEDIATE, MARTS, MARTS_FINANCE, SNAPSHOTS:
        USAGE, CREATE TABLE, CREATE VIEW, MODIFY.

  JAFFLE_SHOP_DEV_ROLE GRANTs
    - DEV Environment:
      - USAGE, MONITOR, CREATE SCHEMA on JAFFLE_SHOP_DEV database.
      - CREATE TABLE, CREATE VIEW, MODIFY on ALL and FUTURE schemas.
    - QA Environment:
      - USAGE and MONITOR on JAFFLE_SHOP_QA database.
    - Production Environment:
      - USAGE on JAFFLE_SHOP database.
      - RAW schema: USAGE + SELECT on ALL and FUTURE tables.

Governance Notes:
  - dbt role receives controlled write privileges across DEV, QA, and production
    modeling schemas to support Slim CI, environment promotion, and artifact
    generation.
  - DEV role receives broader privileges only in the DEV environment, with
    read‑only access to production RAW data to support safe development.
  - RAW schema in production remains read‑only for all roles to preserve data
    lineage and prevent accidental modification.
  - GRANTs are explicit per schema to avoid privilege creep and maintain
    narratable RBAC boundaries.

Usage:
  Designed for public exemplars and reusable in Snowflake to support dbt lesson
  integration and environment‑specific privilege modeling.
------------------------------------------------------------------------------*/
------------------------------------------------------------------------------------
--          5. Privileges & Grants                                                --
------------------------------------------------------------------------------------
USE ROLE SECURITYADMIN;
----------  JAFFLE_SHOP_DBT_ROLE GRANTs  ----------
-- JAFFLE_SHOP_DBT_ROLE role GRANTs on JAFFLE_SHOP_DEV DB objects
GRANT USAGE
      ON DATABASE JAFFLE_SHOP_DEV
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT MONITOR
      ON DATABASE JAFFLE_SHOP_DEV
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT CREATE SCHEMA
      ON DATABASE JAFFLE_SHOP_DEV
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT CREATE TABLE, CREATE VIEW, MODIFY
      ON ALL SCHEMAS IN DATABASE JAFFLE_SHOP_DEV
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT CREATE TABLE, CREATE VIEW, MODIFY
      ON FUTURE SCHEMAS IN DATABASE JAFFLE_SHOP_DEV
      TO ROLE JAFFLE_SHOP_DBT_ROLE;

-- JAFFLE_SHOP_DBT_ROLE role GRANTs on JAFFLE_SHOP_QA DB objects
GRANT USAGE
      ON DATABASE JAFFLE_SHOP_QA
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT MONITOR
      ON DATABASE JAFFLE_SHOP_QA
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT USAGE, CREATE TABLE, CREATE VIEW, MODIFY
      ON ALL SCHEMAS IN DATABASE JAFFLE_SHOP_QA
      TO ROLE JAFFLE_SHOP_DBT_ROLE;

-- JAFFLE_SHOP_DBT_ROLE role GRANTs on JAFFLE_SHOP production DB objects
GRANT USAGE
      ON DATABASE JAFFLE_SHOP
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT MONITOR
      ON DATABASE JAFFLE_SHOP
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT USAGE
      ON SCHEMA JAFFLE_SHOP.RAW
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT SELECT
      ON ALL TABLES IN SCHEMA JAFFLE_SHOP.RAW
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT SELECT
      ON FUTURE TABLES IN SCHEMA JAFFLE_SHOP.RAW
      TO ROLE JAFFLE_SHOP_DBT_ROLE;

GRANT USAGE, CREATE TABLE, CREATE VIEW, MODIFY
      ON SCHEMA JAFFLE_SHOP.REF
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT USAGE, CREATE TABLE, CREATE VIEW, MODIFY
      ON SCHEMA JAFFLE_SHOP.STAGING
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT USAGE, CREATE TABLE, CREATE VIEW, MODIFY
      ON SCHEMA JAFFLE_SHOP.INTERMEDIATE
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT USAGE, CREATE TABLE, CREATE VIEW, MODIFY
      ON SCHEMA JAFFLE_SHOP.MARTS
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT USAGE, CREATE TABLE, CREATE VIEW, MODIFY
      ON SCHEMA JAFFLE_SHOP.MARTS_FINANCE
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT USAGE, CREATE TABLE, CREATE VIEW, MODIFY
      ON SCHEMA JAFFLE_SHOP.SNAPSHOTS
      TO ROLE JAFFLE_SHOP_DBT_ROLE;

----------  JAFFLE_SHOP_DEV_ROLE GRANTs  ----------
-- JAFFLE_SHOP_DEV_ROLE role GRANTs on JAFFLE_SHOP_DEV DB objects
GRANT USAGE
      ON DATABASE JAFFLE_SHOP_DEV
      TO ROLE JAFFLE_SHOP_DEV_ROLE;
GRANT MONITOR
      ON DATABASE JAFFLE_SHOP_DEV
      TO ROLE JAFFLE_SHOP_DEV_ROLE;
GRANT CREATE SCHEMA
      ON DATABASE JAFFLE_SHOP_DEV
      TO ROLE JAFFLE_SHOP_DEV_ROLE;
GRANT CREATE TABLE, CREATE VIEW, MODIFY
      ON ALL SCHEMAS IN DATABASE JAFFLE_SHOP_DEV
      TO ROLE JAFFLE_SHOP_DEV_ROLE;
GRANT CREATE TABLE, CREATE VIEW, MODIFY
      ON FUTURE SCHEMAS IN DATABASE JAFFLE_SHOP_DEV
      TO ROLE JAFFLE_SHOP_DEV_ROLE;

-- JAFFLE_SHOP_DEV_ROLE role GRANTs on JAFFLE_SHOP_QA DB objects
GRANT USAGE
      ON DATABASE JAFFLE_SHOP_QA
      TO ROLE JAFFLE_SHOP_DEV_ROLE;
GRANT MONITOR
      ON DATABASE JAFFLE_SHOP_QA
      TO ROLE JAFFLE_SHOP_DEV_ROLE;

-- JAFFLE_SHOP_DEV_ROLE role GRANTs on JAFFLE_SHOP production DB objects
GRANT USAGE
      ON DATABASE JAFFLE_SHOP
      TO ROLE JAFFLE_SHOP_DEV_ROLE;
GRANT USAGE
      ON SCHEMA JAFFLE_SHOP.RAW
      TO ROLE JAFFLE_SHOP_DEV_ROLE;
GRANT SELECT
      ON ALL TABLES IN SCHEMA JAFFLE_SHOP.RAW
      TO ROLE JAFFLE_SHOP_DEV_ROLE;
GRANT SELECT
      ON FUTURE TABLES IN SCHEMA JAFFLE_SHOP.RAW
      TO ROLE JAFFLE_SHOP_DEV_ROLE;
