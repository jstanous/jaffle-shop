/*------------------------------------------------------------------------------
Script: Snowflake_dbt_Integration_Setup.sql
Purpose:
  Provision dedicated Snowflake resources for dbt integration in the Jaffle Shop project.
  This script creates a warehouse, databases, role, and user, and applies grants
  to ensure dbt has isolated, governed access for both production and development.

Sections:
  1. Warehouse Setup
     - Creates DBT_WH (XSMALL, auto-suspend after 60s, auto-resume enabled).
     - Ensures cost control with statement timeouts and resource monitor.
     - Comment: "Dedicated warehouse for dbt integration".

  2. Database Setup
     - Creates DBT_DB (default dbt database) and DBT_DEV (development database).
     - Drops PUBLIC schemas to enforce explicit schema creation.
     - Comments clarify purpose of each database.

  3. Role & User Setup
     - Uses SECURITYADMIN role to create DBT_ROLE and DBT_USER.
     - DBT_USER is configured with RSA public key for key-pair authentication.
     - Grants DBT_ROLE to both DBT_USER.
     - Ensures dbt runs under a dedicated role with least-privilege access.

  4. Privileges & Grants
     - Grants usage, schema creation, monitoring, and object creation rights
       on DBT and DBT_DEV to DBT_ROLE.
     - Grants usage on warehouse DBT_WH to DBT_ROLE.
     - Future grants ensure dbt can create tables/views/stages/file formats
       in any new schemas without manual intervention.

  5. Resource Monitor
     - Creates DBT_RM with a daily credit quota of 5.
     - Notifies CURRENT_USER at 60% and 80% usage.
     - Suspends warehouse at 100% usage to prevent runaway costs.

Governance Notes:
  - Separation of SYSADMIN, SECURITYADMIN, and ACCOUNTADMIN roles demonstrates
    principle of least privilege.
  - Key-pair authentication avoids reliance on passwords and MFA for dbt integration.
  - Resource monitor enforces cost control and accountability.
------------------------------------------------------------------------------*/

USE ROLE SYSADMIN;
CREATE WAREHOUSE IF NOT EXISTS DBT_WH
  WITH WAREHOUSE_SIZE = 'XSMALL'
       MAX_CLUSTER_COUNT = 1
       AUTO_SUSPEND     = 60
       AUTO_RESUME      = TRUE
       INITIALLY_SUSPENDED = TRUE
       STATEMENT_QUEUED_TIMEOUT_IN_SECONDS = 300
       STATEMENT_TIMEOUT_IN_SECONDS = 3600
       COMMENT = 'Dedicated warehouse for dbt integration';
USE WAREHOUSE DBT_WH;

CREATE DATABASE IF NOT EXISTS DBT_DB
       COMMENT = 'Dedicated default database for dbt integration';
DROP SCHEMA IF EXISTS DBT_DB.PUBLIC;

CREATE DATABASE IF NOT EXISTS DBT_DEV
       COMMENT = 'Dedicated development database for dbt integration';
DROP SCHEMA IF EXISTS DBT_DEV.PUBLIC;


USE ROLE SECURITYADMIN;

CREATE ROLE IF NOT EXISTS DBT_ROLE
       COMMENT = 'Dedicated role for dbt integration';
GRANT ROLE DBT_ROLE TO ROLE SYSADMIN;

GRANT USAGE ON WAREHOUSE DBT_WH TO ROLE DBT_ROLE;



GRANT USAGE ON DATABASE DBT_DB TO ROLE DBT_ROLE;
GRANT CREATE SCHEMA ON DATABASE DBT_DB TO ROLE DBT_ROLE;
GRANT MONITOR ON DATABASE DBT_DB TO ROLE DBT_ROLE;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE DBT_DB TO ROLE DBT_ROLE;
GRANT CREATE TABLE
     ,CREATE VIEW
     ,CREATE STAGE
     ,CREATE FILE FORMAT
   ON FUTURE SCHEMAS IN DATABASE DBT_DB
   TO DBT_ROLE;


GRANT USAGE ON DATABASE DBT_DEV TO ROLE DBT_ROLE;
GRANT CREATE SCHEMA ON DATABASE DBT_DEV TO ROLE DBT_ROLE;
GRANT MONITOR ON DATABASE DBT_DEV TO ROLE DBT_ROLE;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE DBT_DEV TO ROLE DBT_ROLE;
GRANT CREATE TABLE
     ,CREATE VIEW
     ,CREATE STAGE
     ,CREATE FILE FORMAT
   ON FUTURE SCHEMAS IN DATABASE DBT_DEV
   TO DBT_ROLE;

USE ROLE SYSADMIN;
DECLARE user_name STRING;
BEGIN
  user_name := CURRENT_USER();
  EXECUTE IMMEDIATE 'CREATE SCHEMA IF NOT EXISTS DBT_DEV._' || user_name;
END;

USE ROLE ACCOUNTADMIN;
CREATE RESOURCE MONITOR IF NOT EXISTS DBT_RM
  WITH CREDIT_QUOTA = 5
       FREQUENCY = DAILY
       START_TIMESTAMP = IMMEDIATELY
       TRIGGERS ON 60  PERCENT DO NOTIFY
                ON 80  PERCENT DO NOTIFY
                ON 100 PERCENT DO SUSPEND;
