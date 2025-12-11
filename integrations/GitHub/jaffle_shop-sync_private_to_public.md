# Sync Private to Public Exemplar

This GitHub Actions workflow demonstrates how to sync artifacts from a private dbt repo into the public `jaffle-shop` exemplar repository.

## How it works

- **Trigger:** Runs on push to `main` in the private repo, scoped to changes in `/jaffle_shop/*` and `/models/jaffle_shop/*`.

- **Checkouts:**
  - Private repo is checked out into workspace root (`/`).
  - Public repo is checked out into workspace subfolder (`/public-stage/`).

- **Sync:**
  - Non-model artifacts (`/macros/*`, `/seeds/*`, etc.) copied into `/public-stage/`.
  - Model artifacts copied into `/models/*` copied into `/public-stage/models/*`.

- **Rename:** `*.sqlx` files in `/public-stage/macros/` are renamed to `.sql`.
  - `.sqlx` files are used for macro exemplars; renaming ensures compatibility with dbt while preserving exemplar intent.

- **Commit:** Public repo commits are authored by `github-actions[bot]` with provenance message including the private commit SHA.

## Requirements

- A private repo secret (`PAT_Public_JaffleShop`) tied to a Personal Access Token (PAT) with push access to the public repo.
  - **Best practice:** scope the PAT to only the target repository, not org‑wide, to minimize exposure.
