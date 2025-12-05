# Jaffle Shop exemplars for dbt, Snowflake, and GitHub

A concise, governance‑friendly set of exemplars showing how to integrate dbt with Snowflake and GitHub for the Jaffle Shop curriculum. Scripts follow the dbt Certified Developer Path but are adapted, not exact lesson artifacts.

---

## Repository Layout

- integrations/
  - Snowflake/
    - Snowflake_dbt_Integration_Setup.sql — dbt role, warehouse, and integration setup.
    - Snowflake_GitHub_PublicRepo_Setup.sql — public GitHub repo integration (no credentials).
    - Snowflake_GitHub_PrivateRepo_Setup.sql — private GitHub repo integration (PAT secret).
    - Snowflake_JaffleShop_Setup.sql — creates JAFFLE_SHOP database, schemas, and raw tables.
    - Snowflake_JaffleShop_Ingestion.sql — loads exemplar CSVs from public S3 into RAW schema.
  - GitHub/ — placeholder for GitHub-side integration artifacts.

- macros/
  - Utility macros for dbt projects:
    - cents_to_dollars.sql
    - generate_database_name.sqlx
    - generate_schema_name.sqlx

- models/
  - sources/ — source definitions for Jaffle Shop and Stripe.
  - staging/ — staging models for customers, orders, payments.
  - intermediates/ — int_* models and ephemerals for transformations.
  - marts/ — dimensional and fact tables (customers, orders, finance).

- seeds/ — placeholder for seed data.
- snapshots/ — placeholder for snapshot definitions.
- tests/ — custom assertions (e.g., positive totals for payments).

---

> Designed to be consultable and reproducible: each script includes commentary blocks covering steps, roles, and governance notes.

---

## Prerequisites

- **Snowflake roles:** Ability to switch between ACCOUNTADMIN, SYSADMIN, SECURITYADMIN, and a working **DBT_ROLE** for least‑privilege execution.
- **Warehouses & databases:** A compute warehouse (e.g., **DBT_WH**) and permission to create databases/schemas and Git integrations.
- **GitHub:** For private integration, a **PAT** scoped to `repo` and stored as a Snowflake SECRET.
- **dbt (optional):** If you plan to run dbt models/tests, install dbt-snowflake and configure profiles to point at the JAFFLE_SHOP database.

---

## Quick start

1. **Provision environment (Snowflake_JaffleShop_Setup.sql)**
   - **Creates:** JAFFLE_SHOP database; schemas RAW, STAGING, INTERMEDIATES, MARTS; DBT.JAFFLE_SHOP internal schema.
   - **Governance:** Drops PUBLIC schemas; alternates roles (SYSADMIN for objects, SECURITYADMIN for grants).

2. **Load exemplar data (Snowflake_JaffleShop_Ingestion.sql)**
   - **Loads:** PUBLIC S3 CSVs into RAW.CUSTOMERS, RAW.ORDERS, RAW.PAYMENTS via COPY INTO with CSV file format.
   - **Validate:** Run trailing SELECTs to confirm row counts and basic ingestion health.

3. **Integrate repo (choose one)**
   - **Public:** Create API integration with `git_https_api`, allowed prefix for public repo, and a Snowflake Git repository object.
   - **Private:** Create SECRET with PAT; API integration allowing the secret; Snowflake Git repository object with credentials.

4. **Optional: dbt flow**
   - **Run dbt:** `dbt deps && dbt seed && dbt run && dbt test`
   - **Target schemas:** STAGING, INTERMEDIATES, MARTS under JAFFLE_SHOP.

---

## Governance notes

- **Least‑privilege:** Separate object creation (SYSADMIN) from grants (SECURITYADMIN). Run ingestion under **DBT_ROLE**.
- **Schema hygiene:** Drop PUBLIC schemas to enforce explicit paths; isolate integration artifacts in **DBT.JAFFLE_SHOP** and GitHub schema.
- **Secrets & rotation:** Private integration uses PATs in Snowflake SECRET objects; rotate regularly and scope to `repo`.
- **Lineage & auditability:** Raw tables include ETL timestamps; comments on objects clarify purpose.

---

## Project layout

- **Top‑level folders:** analyses, integrations, macros, models, seeds, snapshots, tests.
- **Key files:** `dbt_project.yml` (project config), `LICENSE` (MIT).  
- **About:** Repo description emphasizes Jaffle Shop exemplars adapted for Snowflake/GitHub integration.

---

## License

- **MIT License:** Permissive use with attribution and no warranty. See `LICENSE` in the repo.








# dbt Jaffle Shop with Snowflake & GitHub Integration

This repo contains exemplar scripts and models for integrating dbt with Snowflake and GitHub, inspired by the dbt Certified Developer Path. Scripts reflect lesson concepts but are adapted for Snowflake/GitHub integration — not exact lesson artifacts.

---


## Quick Start

1. Provision environment
   Run integrations/Snowflake/Snowflake_JaffleShop_Setup.sql in Snowflake.

2. Ingest exemplar data
   Run integrations/Snowflake/Snowflake_JaffleShop_Ingestion.sql in Snowflake.

3. Integrate GitHub repo
   - Public: run Snowflake_GitHub_PublicRepo_Setup.sql
  

---

## Governance Notes

- Least privilege: SYSADMIN for object creation, SECURITYADMIN for grants, DBT_ROLE for ingestion.
- Schema hygiene: PUBLIC schemas dropped; explicit schemas for RAW, STAGING, INTERMEDIATES, MARTS.
- Secrets: PATs stored in Snowflake SECRET objects for private repo integration.
- Lineage: Raw tables include ETL timestamps; doc markdown files provide context.

---

## Usage

This repo is designed as a consultable exemplar:
- Public repo demonstrates credential-free integration.
- Private repo scripts show enterprise-ready integration with secrets.
- Models follow dbt’s Certified Developer Path structure for clarity and reproducibility.

---

## License

MIT License — permissive use with attribution, no warranty.
   - Private: run Snowflake_GitHub_PrivateRepo_Setup.sql (requires PAT secret)

4. Run dbt
