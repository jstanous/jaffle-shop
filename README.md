# Jaffle Shop Exemplars for dbt, Snowflake, and GitHub

A governance‑friendly set of exemplars showing how to integrate **dbt** with **Snowflake** and **GitHub** for the Jaffle Shop curriculum.  
Scripts follow the dbt Certified Developer Path but are adapted, not exact lesson artifacts.

## Repo Structure

```text
jaffle-shop/
├─ README.md                   # Commentary registry and exemplar overview
├── integrations/
│   ├── Snowflake/             # Snowflake integration scripts
│   └── GitHub/                # GitHub integration artifacts
├── macros/                    # Utility macros (cents_to_dollars, schema/database generators)
├── models/
│   ├── sources/               # Source definitions for Jaffle Shop and Stripe
│   ├── staging/               # Staging models for customers, orders, payments
│   ├── intermediates/         # Intermediate models customers, orders, payments
│   │   └── ephemerals/        # Ephemerals models with transformation logic
│   └── marts/                 # Common Dimensional tables  
│       └── finance/           # Finance domain fact tables
├── seeds/                     # Placeholder for seed data
├── snapshots/                 # Placeholder for snapshot definitions
└── tests/                     # Custom assertions (e.g., positive totals for payments)
```

## Repo Maintenance

This repository is **not developed directly**.  
It serves as a **public exemplar feed**, synchronized from a private dbt Learning repository via **GitHub Actions**.

- **Private repo:** Active development, experimentation, and course‑aligned work  
- **Public repo:** Curated exemplars for consultable, governance‑friendly reference  
- **Automation:** GitHub Actions push artifacts from private to public  
- **Implication:** Direct edits here are discouraged; changes should be made in the private repo and propagated automatically

This design ensures:

- Clear separation between private learning work and public exemplars  
- Reproducibility and auditability through automated sync pipelines  
- A clean, stakeholder‑grade repo aligned with the dbt Certified Developer Path

## Prerequisites

This repository is designed for **dbt** with **Snowflake**.  
Other warehouses may adapt the modeling approach, but the integration scripts require Snowflake.

- **dbt:** Working dbt setup and configured to point at your target database  
- **GitHub:** Ability to clone/pull from a GitHub repo. For private integration, a PAT scoped to `repo` stored securely  
- **Database environment:** A compatible database/schema where dbt can create and manage objects  
- **Snowflake (required for integration scripts):** Permissions to create warehouses, databases, schemas, and roles  

## Quick Start

1. **Setup Snowflake for dbt (if not already provisioned)**  
   Run `integrations/Snowflake/Snowflake_dbt_Integration_Setup.sql`  
   - Creates dedicated warehouse (**DBT_WH**) with autosuspend/autoresume  
   - Creates default (**DBT**) and development (**DBT_DEV**) databases  
   - Drops PUBLIC schemas  
   - Creates **DBT_ROLE** with least‑privilege grants and assigns to current user  
   - Creates resource monitor (**DBT_RM**) for credit quota and notifications  

2. **Setup Jaffle Shop environment**  
   Run `integrations/Snowflake/Snowflake_JaffleShop_Setup.sql`  
   - Creates **JAFFLE_SHOP** database and schemas (RAW, STAGING, INTERMEDIATES, MARTS)  
   - Drops PUBLIC schemas  
   - Uses SYSADMIN for object creation and SECURITYADMIN for grants  

3. **Load Jaffle Shop data**  
   Run `integrations/Snowflake/Snowflake_JaffleShop_Ingestion.sql`  
   - Loads CSVs from public S3 into RAW tables (CUSTOMERS, ORDERS, PAYMENTS)  
   - Validates ingestion with trailing SELECTs  

4. **Optional: Snowflake/GitHub Integration**  
   - **Public:** Run `Snowflake_GitHub_PublicRepo_Setup.sql` to create API integration with `git_https_api` and Snowflake Git repository object  
   - **Private:** Run `Snowflake_GitHub_PrivateRepo_Setup.sql` to create SECRET with PAT, API integration allowing the secret, and Snowflake Git repository object with credentials

## Approach

- **Modeling**
  - **Layering discipline:** `src → stg → int (eph) → dim/fct` aligns with dbt best practices.  
  - **Source artifacts (`src`):** Source YAML and markdown files are kept in dedicated `/sources/` directories.  
  - **Staging models (`stg`):** Organized into subfolders reflecting source systems.  
  - **Ephemeral models (`eph`):** Transformation logic isolated here to enforce modularity.  
  - **Intermediate models (`int`):** Assembles staging and transformational ephemeral models.  
  - **Marts models (`dim`/`fct`):** Final dimensional and fact tables, ready for analysis and consumption.  

- **Documentation**
  - **Commentary:** SQL integration scripts include structured commentary for consultation.  
  - **Doc blocks:** Source, table, model, and column documentation maintained in model‑specific markdown files.  
  - **Lineage:** Column doc blocks reference their model of origin.  

- **Governance**
  - **Least‑privilege:**  
    - SYSADMIN for object creation  
    - SECURITYADMIN for grants  
    - DBT_ROLE for ingestion/modeling  
  - **Schema hygiene:**  
    - PUBLIC schemas dropped  
    - Integration artifacts isolated in `DBT.JAFFLE_SHOP` and `DBT.GITHUB` schemas  
    - Development artifacts housed in `DBT_DEV` database  
  - **Secrets & rotation:** PATs stored in Snowflake SECRET objects; rotate regularly and scope to `repo`.  
  - **Auditability:** Raw tables include ETL timestamps; commentary blocks and markdown notes clarify purpose.

## dbt Learning Path

This project aligns with the **dbt Certified Developer Path**.  
Courses marked with ✅ have been completed.

### Milestone #1: dbt Fundamentals

- **dbt Fundamentals (dbt Studio)** ✅ — foundational steps with dbt Studio; ~5 hours  
- **dbt Fundamentals (VS Code)** — foundational steps with VS Code Extension; ~5 hours  

### Milestone #2: Jinja, Macros, and Packages

- **Jinja, Macros, and Packages (dbt Studio)** ✅ — extend dbt with Jinja/macros; ~2 hours  
- **Jinja, Macros, and Packages (VS Code)** — extend dbt with VS Code Extension; ~2 hours  

### Milestone #3: Advanced dbt Techniques

- **Refactoring SQL for Modularity** ✅ — migrate legacy code into modular dbt models; ~3.5 hours  
- **Incremental Models** — build models incrementally; ~1.5 hours  
- **Snapshots** — track historical records with slowly changing dimensions  
- **Analyses and Seeds (dbt Studio)** — ad hoc queries and seed CSVs; ~1 hour  
- **Exposures** — configure downstream dependencies; ~2 hours  
- **Understanding State** — state management in dbt; ~4 minutes  
- **dbt retry** — rebuild pipelines efficiently; ~3 minutes  
- **dbt Mesh Introduction** — overview for certification exam; ~1 minute  
- **dbt Mesh** — boost reliability and speed at scale  
- **Advanced Testing** — custom tests and configurations; ~4 hours  
- **Advanced Deployment** — CI/CD and advanced deployment; ~4 hours  
- **dbt Clone** — create database object copies; ~5 minutes  
- **Grants** — control permissions for models/seeds/snapshots; ~6 minutes  
- **Python Models** — leverage Python for non‑SQL use cases; ~6 minutes  

## License

MIT License — permissive use with attribution, no warranty.  
See LICENSE in the repo.

## Final Thoughts

The Jaffle Shop project illustrates a simplified data architecture.  
This repository is intended to demonstrate understanding and application of dbt best practices as practiced in dbt coursework.  

It includes governance‑friendly practices for dbt + Snowflake integration, including:

- Clear layering discipline (`src → stg → eph → int → dim/fct`)
- Heavy use of ephemerals to enforce modularity and reduce clutter
- Structured commentary and doc blocks for reproducibility
- Least‑privilege execution and schema hygiene
- Automated sync from private learning repo to public exemplar feed

The goal is to provide a reference that aligns with the dbt Certified Developer Path while remaining adaptable for future extensions.
