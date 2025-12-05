# Jaffle Shop exemplars for dbt, Snowflake, and GitHub

A concise, governance‑friendly set of exemplars showing how to integrate dbt with Snowflake and GitHub for the Jaffle Shop curriculum. Scripts follow the dbt Certified Developer Path but are adapted, not exact lesson artifacts.

---

## What this repo contains

- **Snowflake environment setup:** Database, lesson‑aligned schemas (RAW, STAGING, INTERMEDIATES, MARTS), and raw tables with lineage timestamps.
- **Public GitHub integration:** API integration and Snowflake Git repository object for the public Jaffle Shop repo (no credentials).
- **Private GitHub integration:** PAT‑based secret, API integration, and cloned repo object (credentials required and rotated).
- **Data ingestion:** COPY INTO statements from public S3 to load CUSTOMERS, ORDERS, PAYMENTS into RAW.

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
