/*------------------------------------------------------------------------------
Script: Snowflake_Setup_Step1_JaffleShop_Roles.sql

Purpose:
  Provision dedicated Snowflake ROLEs for the Jaffle Shop project.
  This script creates a user and roles for governed access by purpose.

Sections:
  Uses SECURITYADMIN role.
  Role Setup
  - Creates individual ROLEs as;
    JAFFLE_SHOP_DBT_ROLE used by dbt for build/run operations during Slim CI simulations
    JAFFLE_SHOP_DEV_ROLE used by development resources
    JAFFLE_SHOP_FINANCE_ROLE and JAFFLE_SHOP_ANALYST_ROLE used to analyst role simulation.
  User Setup
  - Creates JAFFLE_SHOP_DBT_USER configured with RSA public key for key-pair authentication.
  - Assigns JAFFLE_SHOP_DBT_USER to JAFFLE_SHOP_DBT_ROLE.
  User Assignments
  - Assigns CURRENT_USER to JAFFLE_SHOP_DEV_ROLE, JAFFLE_SHOP_FINANCE_ROLE, and JAFFLE_SHOP_ANALYST_ROLE.

Governance Notes:
  - Ensures dbt operates under dedicated roles with least-privilege access.
  - Key-pair authentication avoids reliance on passwords and MFA for dbt integration.
  - JAFFLE_SHOP_FINANCE_ROLE and JAFFLE_SHOP_ANALYST_ROLE grants are intended for management by dbt.

Usage:
  Designed for public exemplars and reusable in Snowflake to support dbt lesson integration.
------------------------------------------------------------------------------*/
------------------------------
--     Role Setup           --
------------------------------
USE ROLE SECURITYADMIN;
CREATE ROLE IF NOT EXISTS JAFFLE_SHOP_DBT_ROLE
       COMMENT = 'Dedicated role for Jaffle Shop dbt integration';
CREATE ROLE IF NOT EXISTS JAFFLE_SHOP_DEV_ROLE
       COMMENT = 'Dedicated role for Jaffle Shop Developers';
CREATE ROLE IF NOT EXISTS JAFFLE_SHOP_FINANCE_ROLE
       COMMENT = 'Dedicated role for Jaffle Shop Finance Department';
CREATE ROLE IF NOT EXISTS JAFFLE_SHOP_ANALYST_ROLE
       COMMENT = 'Dedicated role for Jaffle Shop Analysts';

------------------------------
--     User Setup           --
------------------------------
CREATE USER IF NOT EXISTS JAFFLE_SHOP_DBT_USER
       DEFAULT_ROLE = JAFFLE_SHOP_DBT_ROLE
       DEFAULT_WAREHOUSE = JAFFLE_SHOP_WH
       MUST_CHANGE_PASSWORD = FALSE
       RSA_PUBLIC_KEY = '<PASTE_PUBLIC_KEY_HERE>'
       COMMENT = 'dbt service account for Jaffle Shop project';
GRANT ROLE JAFFLE_SHOP_DBT_ROLE     TO USER JAFFLE_SHOP_DBT_USER;

------------------------------
--     User Assignments     --
------------------------------
SET CURRENT_USER = (SELECT CURRENT_USER());   
GRANT ROLE JAFFLE_SHOP_DEV_ROLE     TO USER IDENTIFIER($CURRENT_USER);
GRANT ROLE JAFFLE_SHOP_FINANCE_ROLE TO USER IDENTIFIER($CURRENT_USER);
GRANT ROLE JAFFLE_SHOP_ANALYST_ROLE TO USER IDENTIFIER($CURRENT_USER);
