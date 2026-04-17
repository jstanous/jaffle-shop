/*------------------------------------------------------------------------------
Script: Snowflake_Setup_Step2_JaffleShop_Compute.sql

Purpose:
  Provision dedicated Snowflake WAREHOUSE and RESOURCE MONITOR for Jaffle Shop project.

Sections:
  Warehouse Setup
  - Creates JAFFLE_SHOP_WH (XSMALL, auto-suspend after 30s, auto-resume enabled).
  - Ensures cost control with queue and statement timeouts.
  - Uses SYSADMIN role.
  Resource Monitor Setup
  - Creates JAFFLE_SHOP_RM with a daily credit quota of 5.
  - Notifies CURRENT_USER at 60% and 80% usage.
  - Suspends warehouse at 100% usage to prevent runaway costs.
  - Uses ACCOUNTADMIN role.
  Warehouse Usage Grants
  - GRANTs USAGE on JAFFLE_SHOP_WH to each ROLE individually
  - ROLEs: JAFFLE_SHOP_DBT_ROLE, JAFFLE_SHOP_DEV_ROLE, JAFFLE_SHOP_FINANCE_ROLE, and JAFFLE_SHOP_ANALYST_ROLE

Governance Notes:
  - Role usage switching between SYSADMIN (warehouse creation) and ACCOUNTADMIN (resource monitor creation)
    demonstrates required privileges under Snowflake security architecture.
  - Resource monitor enforces cost control and accountability.

Usage:
  Designed for public exemplars and reusable in Snowflake to support dbt lesson integration.
------------------------------------------------------------------------------*/
------------------------------------
--     Warehouse Setup            --
------------------------------------
USE ROLE SYSADMIN;
CREATE WAREHOUSE IF NOT EXISTS JAFFLE_SHOP_WH
  WITH WAREHOUSE_SIZE = 'XSMALL'
       MAX_CLUSTER_COUNT = 1
       AUTO_SUSPEND = 30
       AUTO_RESUME = TRUE
       INITIALLY_SUSPENDED = TRUE
       STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = 300
       STATEMENT_TIMEOUT_IN_SECONDS = 1800
       COMMENT = 'Dedicated warehouse for dbt Jaffle Shop project';
USE WAREHOUSE JAFFLE_SHOP_WH;

------------------------------------
--     Resource Monitor Setup     --
------------------------------------
USE ROLE ACCOUNTADMIN;
CREATE RESOURCE MONITOR IF NOT EXISTS JAFFLE_SHOP_RM
  WITH CREDIT_QUOTA = 5
       FREQUENCY = DAILY
       START_TIMESTAMP = IMMEDIATELY
       TRIGGERS ON 60  PERCENT DO NOTIFY
                ON 80  PERCENT DO NOTIFY
                ON 100 PERCENT DO SUSPEND;
ALTER WAREHOUSE JAFFLE_SHOP_WH SET RESOURCE_MONITOR = JAFFLE_SHOP_RM;

------------------------------------
--     Warehouse Usage Grants     --
------------------------------------
GRANT USAGE
      ON WAREHOUSE JAFFLE_SHOP_WH
      TO ROLE JAFFLE_SHOP_DBT_ROLE;
GRANT USAGE
      ON WAREHOUSE JAFFLE_SHOP_WH
      TO ROLE JAFFLE_SHOP_DEV_ROLE;
GRANT USAGE
      ON WAREHOUSE JAFFLE_SHOP_WH
      TO ROLE JAFFLE_SHOP_FINANCE_ROLE;
GRANT USAGE
      ON WAREHOUSE JAFFLE_SHOP_WH
      TO ROLE JAFFLE_SHOP_ANALYST_ROLE;
