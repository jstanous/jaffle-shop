/*------------------------------------------------------------------------------
Script: Snowflake_Github_PublicRepo_Setup.sql
Purpose:
  Provision Snowflake resources to integrate with the public Jaffle Shop GitHub
  repository. This script establishes a dedicated database and schema for
  integration artifacts, configures an API integration for Git over HTTPS,
  and creates a Git repository object to fetch and manage repo contents.

Steps:
  1. Warehouse Usage
     - Uses COMPUTE_WH as the default warehouse for integration tasks.
     - Assumes warehouse already exists; no new warehouse is provisioned.

  2. Database & Schema Setup
     - Creates DBT database if not already present.
     - Creates GITHUB schema to house integration objects.
     - Drops DBT.PUBLIC schema to enforce explicit schema usage.

  3. API Integration
     - Uses ACCOUNTADMIN role to create API integration GITHUB_JAFFLE_SHOP.
     - API_PROVIDER set to git_https_api for GitHub connectivity.
     - API_ALLOWED_PREFIX points to the public Jaffle Shop repo URL.
     - No secrets required since repo is public. 

  4. Git Repository Object
     - Uses SYSADMIN role to create Git repository JAFFLE_SHOP.
     - Associates repository with the API integration.
     - ORIGIN points to the public Jaffle Shop repo URL.

  5. Fetch Latest Contents
     - Executes ALTER GIT REPOSITORY JAFFLE_SHOP FETCH.
     - Ensures Snowflake workspace is updated with the latest repo contents.
     - Provides foundation for downstream directory creation or file inspection.

  6. Snowflake Workspace Setup
     - In Snowsight, LeftNav Pane, select Projects -> Workspaces.
     - In Workspace Pane, open Workspace Dropdown (upper-left corner).
     - Under Create, select 'From Git Repository'.
     - Populate the URL for the repo.
     - Choose a Workspace name.
     - Select the API Integration that was just created.
     - Click Create to provision the workspace.

Governance Notes:
  - Separation of ACCOUNTADMIN (integration creation) and SYSADMIN (repo management)
    demonstrates principle of least privilege.
  - Public repo integration avoids credential management complexity; no PATs or secrets
    are required.
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

-- 3. API Integration
USE ROLE ACCOUNTADMIN;
CREATE OR REPLACE API INTEGRATION GITHUB_JAFFLE_SHOP
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/<github username>/jaffle_shop.git')
  ENABLED = TRUE
  COMMENT = 'Dedicated API integration for public Jaffle Shop GitHub repo access (no credentials required)';

-- 4. Git Repository Object
USE ROLE SYSADMIN;
CREATE OR REPLACE GIT REPOSITORY JAFFLE_SHOP
  API_INTEGRATION = GITHUB_JAFFLE_SHOP
  ORIGIN = 'https://github.com/<github username>/jaffle_shop.git'
  COMMENT = 'Jaffle Shop repo cloned into Snowflake';

-- 5. Fetch Latest Contents
ALTER GIT REPOSITORY JAFFLE_SHOP FETCH;
