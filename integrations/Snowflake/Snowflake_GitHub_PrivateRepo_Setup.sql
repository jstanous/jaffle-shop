/*------------------------------------------------------------------------------
Script: Snowflake_Github_PrivateRepo_Setup.sql
Purpose:
  Provision Snowflake resources to integrate with a private Jaffle Shop GitHub
  repository. This script establishes a dedicated database and schema for
  integration artifacts, configures an API integration for Git over HTTPS with
  credentialed access, and creates a Git repository object to fetch and manage
  repo contents.

Steps:
  1. Warehouse Usage
     - Uses COMPUTE_WH as the default warehouse for integration tasks.
     - Assumes warehouse already exists; no new warehouse is provisioned.

  2. Database & Schema Setup
     - Creates DBT database if not already present.
     - Creates GITHUB schema to house integration objects.
     - Drops DBT.PUBLIC schema to enforce explicit schema usage.

  3. Secret Creation
     - Creates a Snowflake SECRET object named GITHUB_JAFFLE_SHOP.
     - Stores GitHub username and Personal Access Token (PAT) for private repo access.
     - PAT must be scoped with 'repo' permissions; password authentication is not supported.

  4. API Integration
     - Uses ACCOUNTADMIN role to create API integration GITHUB_JAFFLE_SHOP.
     - API_PROVIDER set to git_https_api for GitHub connectivity.
     - API_ALLOWED_PREFIX points to the private Jaffle Shop repo URL.
     - ALLOWED_AUTHENTICATION_SECRETS includes the GITHUB_JAFFLE_SHOP secret.

  5. Git Repository Object
     - Uses SYSADMIN role to create Git repository GITHUB_JAFFLE_SHOP.
     - Associates repository with the API integration and secret credentials.
     - ORIGIN points to the private Jaffle Shop repo URL.

  6. Fetch Latest Contents
     - Executes ALTER GIT REPOSITORY GITHUB_JAFFLE_SHOP FETCH.
     - Ensures Snowflake workspace is updated with the latest repo contents.
     - Provides foundation for downstream directory creation or file inspection.

  7. Snowflake Workspace Setup
     - In Snowsight, LeftNav Pane, select Projects -> Workspaces.
     - In Workspace Pane, open Workspace Dropdown (upper-left corner).
     - Under Create, select 'From Git Repository'.
     - Populate the URL for the private repo.
     - Choose a Workspace name.
     - Select the API Integration that was just created.
     - Click Create to provision the workspace.

Governance Notes:
  - Separation of ACCOUNTADMIN (integration creation) and SYSADMIN (repo management)
    demonstrates principle of least privilege.
  - Private repo integration requires credential management via PATs stored in Snowflake
    secrets; PATs should be rotated regularly for security hygiene.
  - Schema hygiene enforced by dropping PUBLIC schema and isolating artifacts in GITHUB.
  - Snowsight Workspace setup provides a UI-driven path for developers to interact with
    the cloned repo directly in Snowflake.
------------------------------------------------------------------------------*/

-- 1. Warehouse Usage
USE WAREHOUSE COMPUTE_WH;

-- 2. Database & Schema Setup
CREATE DATABASE IF NOT EXISTS DBT
       COMMENT = 'Dedicated default database for dbt integration';
USE DATABASE DBT;

CREATE SCHEMA IF NOT EXISTS GITHUB 
  COMMENT = 'Dedicated schema for snowflake github integration objects';
USE SCHEMA GITHUB;
DROP SCHEMA IF EXISTS DBT.PUBLIC;

-- 3. Secret Creation
CREATE OR REPLACE SECRET GITHUB_JAFFLE_SHOP
  TYPE = PASSWORD
  USERNAME = '<github username>'
  PASSWORD = '<github PAT>'
  COMMENT = 'Dedicated PAT for github access to private jaffle-shop repo';

-- 4. API Integration
USE ROLE ACCOUNTADMIN;
CREATE API INTEGRATION IF NOT EXISTS GITHUB_JAFFLE_SHOP
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/<github username>/dbt_Learning.git')
  ENABLED = TRUE
  ALLOWED_AUTHENTICATION_SECRETS = ('GITHUB_JAFFLE_SHOP')
  COMMENT = 'Dedicated API integration for private Jaffle Shop GitHub repo access (PAT credential required)';

-- 5. Git Repository Object
USE ROLE SYSADMIN;
CREATE GIT REPOSITORY IF NOT EXISTS GITHUB_JAFFLE_SHOP
  API_INTEGRATION = GITHUB_JAFFLE_SHOP
  GIT_CREDENTIALS = GITHUB_JAFFLE_SHOP
  ORIGIN = 'https://github.com/jstanous/dbt_Learning.git'
  COMMENT = 'jaffle-shop github repo';

-- 6. Fetch Latest Contents
ALTER GIT REPOSITORY GITHUB_JAFFLE_SHOP FETCH;
