# Jaffle Shop Exemplars for dbt, Snowflake, and GitHub in VS Code

A cert-prep aligned set of exemplars showing how to integrate **dbt** with **Snowflake** and **GitHub** using the dbt Developer Path's Jaffle Shop curriculum using **VS Code** and **dbt Fusion**.  
Scripts follow the dbt Certified Developer Path but are not always exact lesson artifacts.  
This repo demonstrates DEV → QA → PROD workflows with environment‑aware configuration and Slim CI simulations to model real-world deployment paths.  
This repo is used as hands-on study guide to prepare for the **dbt Analytics Engineering** certification.  

## Repo Structure

```text
jaffle-shop/
├─ README.md               Repository overview and setup guide
├─ dbt_project.yml         dbt project configuration
├─ packages.yml            dbt package installation file
├─ LICENSE                 Repository License
├── _artifacts/            dbt Lesson artifacts
├── _integrations/
│   └── Snowflake/         Snowflake setup and integration scripts
├── .dbt/profiles.yml      Multi-database profile configuration exemplar
├── .scripts/              Powershell Slim CI simulation scripts
├── .vscode/               VS Code Setup exemplars and tasks and configs for Slim CI
├── analyses/              SQL analyses for data profiling and exploration
├── macros/                dbt Jinja macro utilities and functions
├── meta/                  Doc Blocks:
│   ├── sources/             Jaffle Shop and Stripe source definitions
│   ├── staging/             Staging model documentation
│   ├── intermediate/        Intermediate model documentation
│   │   └── ephemeral/       Ephemeral models (derived column) documentation
│   └── marts/               Common dimensional model documentation
│       └── finance/         Finance-domain fact model documentation
├── models/                dbt model definitions and configurations:
│   ├── sources/             Raw data schema source definitions
│   ├── staging/             Staging models for customers, orders, and payments
│   ├── intermediate/        Intermediate models
│   │   └── ephemeral/         Ephemeral transformation logic
│   ├── marts/               Common dimensional models
│   │   └── finance/           Finance-domain fact models
│   └── exposures/           Downstream uses of marts models
├── seeds/                 Reference data seeds
├── snapshots/             Slowly-changing dimension snapshot definitions
├── target/prod/           dbt Doc Site artifacts (production build)
└── tests/                 Custom data assertion tests
```

## Prerequisites

This project is designed for **dbt** with **Snowflake** using **VS Code** and requires:

- **Python** environment with dbt-snowflake installed  
- **VS Code** with the **dbt** and **Snowflake** extensions  
- **PowerShell** for running Slim CI simulation scripts in the `.scripts` directory
- **Snowflake** access with permissions to create warehouses, databases, schemas, and roles
- **GitHub** access for cloning the repository
- **Key Pairs** are required for both **dbt/Snowflake** integration and the **Snowflake VS Code** extension

### Key Pairs  

This project uses key‑pair authentication for Snowflake.

- dbt Core requires an open (unencrypted) RSA key pair for JWT authentication.  
The Step1 setup script (Snowflake_Setup_Step1_JaffleShop_Roles.sql) includes the location where the public key must be supplied.
- The Snowflake VS Code extension requires an encrypted private key only if MFA is enforced in your Snowflake account.  
If MFA is not required, the extension can authenticate without an encrypted key pair.

Only public keys are added to Snowflake during user setup.
Any method of generating RSA key pairs is acceptable as long as it produces:

- a private key (encrypted or unencrypted, depending on use)
- a corresponding public key compatible with Snowflake

## My Environment & Setup  

This is the environment used for my **dbt** projects in **VS Code**. It does not need to be replicated exactly, but is provided as reference.

### Python  

I use Miniconda with a dedicated environment for dbt projects. Miniconda allows a minimal base environment and only required libraries are installed for dbt projects.  

- Installed **Miniconda 25.11.1 with Python 3.11**:  
[Miniconda3‑py311_25.11.1‑1‑Windows‑x86_64.exe](https://repo.anaconda.com/miniconda/Miniconda3-py311_25.11.1-1-Windows-x86_64.exe)  

- Created a dedicated environment for **dbt**:  

    ```bash
    conda create -n dbt-dev python=3.11
    conda activate dbt-dev
    pip install dbt-snowflake
    ```

    This environment must match the interpreter path in `.vscode/settings.json`:

    ```jsonc
    "python.defaultInterpreterPath": "<path-to-python>/envs/dbt-dev/python.exe"
    ```

### VS Code  

- Installed the below extensions to support project development and execution  
  - dbt extension with Fusion upgrade  
  - Snowflake extension  
- Interpreter pinned to the dbt-dev environment via .vscode/settings.json  
- Windows 11 PowerShell as default terminal  
  - Repository root as terminal root
  - dbt-dev environment activated automatically
  - explicit file-extension associations for proper interpreter use.

### Snowflake  

- Standard-level paid edition
- SYSADMIN, SECURITYADMIN, ACCOUNT_ADMIN access for setup scripts

### dbt  

- dbt Core installed in `dbt-dev` Conda environment  
- Fusion enabled though the dbt VS Code extension  
- dbt Core tied to dbt Cloud through cloud.yml in local `/.dbt/` directory  
- Multi-database profiles.yml exemplar copied into profiles.yml in local `/.dbt/` directory  

### Environment Variables  

This project relies on environment variables (EnvVars) for storing sensitive information used within the project. All of the EnvVars are used in the profiles.yml. Set the following variables using any method supported by your operating system or shell:

- SNOWFLAKE_ACCOUNT
- SNOWFLAKE_USER
- SNOWFLAKE_USER_PRIVATE_KEY_PATH
- SNOWFLAKE_USER_PRIVATE_PASSPHRASE
- SNOWFLAKE_DBT_PRIVATE_KEY_PATH

These variables allow dbt Core and the VS Code dbt extension (Fusion) to authenticate using your local RSA key pair.

## Quick Start

Once the environment setup is completed, the scripts in `/_integrations/Snowflake` allow quick creation of required Snowflake roles, warehouse, resource monitor, database objects, data ingestion, and permissions needed to run this project.

The following scripts are designed for ordered execution. Each script contains its own commentary block with script details.  

- Snowflake_Setup_Step1_JaffleShop_Roles.sql  
- Snowflake_Setup_Step2_JaffleShop_Compute.sql  
- Snowflake_Setup_Step3_JaffleShop_Objects.sql  
- Snowflake_Setup_Step4_JaffleShop_Ingestion.sql  
- Snowflake_Setup_Step5_JaffleShop_Grants.sql  
  
**Optional: Snowflake/GitHub Integration**  
If **GitHub/Snowflake** integration is required for work in the **Snowflake Horizon UI**, Snowflake_Setup_Optional_GitHub_PublicRepo_Integration.sql provides the framework to connect **Snowflake** to a **GitHub** public repo.

## dbt Learning Path

This project aligns with the **dbt Certified Developer Path**.

### Milestone #1: dbt Fundamentals

- ✅ **dbt Fundamentals (dbt Studio)** — foundational steps with dbt Studio; ~5 hours  
- **dbt Fundamentals (VS Code)** — foundational steps with VS Code Extension; ~5 hours  

### Milestone #2: Jinja, Macros, and Packages

- ✅ **Jinja, Macros, and Packages (dbt Studio)** — extend dbt with Jinja/macros; ~2 hours  
- **Jinja, Macros, and Packages (VS Code)** — extend dbt with VS Code Extension; ~2 hours  

### Milestone #3: Advanced dbt Techniques

- ✅ **Refactoring SQL for Modularity** — migrate legacy code into modular dbt models; ~3.5 hours  
- ✅ **Incremental Models** — build models incrementally; ~1.5 hours  
- ✅ **Snapshots** — track historical records with slowly changing dimensions  
- ✅ **Analyses and Seeds (dbt Studio)** — ad hoc queries and seed CSVs; ~1 hour  
- ✅ **Exposures** — configure downstream dependencies; ~2 hours  
- ✅ **Understanding State** — state management in dbt; ~4 minutes  
- ✅ **dbt retry** — rebuild pipelines efficiently; ~3 minutes  
- ✅ **dbt Mesh Introduction** — overview for certification exam; ~1 minute  
- ✅ **dbt Mesh** — boost reliability and speed at scale  
- ✅ **Advanced Testing** — custom tests and configurations; ~4 hours  
- ✅ **Advanced Deployment** — CI/CD and advanced deployment; ~4 hours  
- ✅ **dbt Clone** — create database object copies; ~5 minutes  
- ✅ **Grants** — control permissions for models/seeds/snapshots; ~6 minutes  
- ✅ **Python Models** — leverage Python for non‑SQL use cases; ~6 minutes  

## License

MIT License — permissive use with attribution, no warranty.  
See LICENSE in the repo.  
