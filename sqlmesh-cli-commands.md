# SQLMesh CLI Cheat Sheet

## Project Setup
| Command | Description |
|---------|-------------|
| `sqlmesh init snowflake` | Scaffold a new project with Snowflake config |
| `sqlmesh info` | Show project config, connection status, model count |
| `sqlmesh ui` | Launch the browser-based UI |

## Core Workflow
| Command | Description |
|---------|-------------|
| `sqlmesh plan` | Diff local state vs prod — shows what will change before touching anything |
| `sqlmesh plan dev` | Same but targets a dev environment |
| `sqlmesh plan --auto-apply` | Plan and apply without prompting |
| `sqlmesh run` | Execute scheduled intervals that are missing (catch up) |
| `sqlmesh run dev` | Catch up a dev environment |

## Development
| Command | Description |
|---------|-------------|
| `sqlmesh render <model>` | Print the final compiled SQL for a model |
| `sqlmesh evaluate <model>` | Run a model and return results as a dataframe |
| `sqlmesh fetchdf "SELECT ..."` | Run an ad-hoc SQL query and display results |
| `sqlmesh diff <env>` | Show diff between local state and an environment |
| `sqlmesh format` | Auto-format all SQL model files |

## Quality & Testing
| Command | Description |
|---------|-------------|
| `sqlmesh lint` | Run linter rules against all models |
| `sqlmesh test` | Run unit tests (YAML test fixtures in `tests/`) |
| `sqlmesh audit` | Run data quality audits against built model data |
| `sqlmesh create_test <model>` | Auto-generate a unit test fixture for a model |
| `sqlmesh table_diff <a> <b>` | Compare two tables row-by-row |

## Environments & State
| Command | Description |
|---------|-------------|
| `sqlmesh environments` | List all SQLMesh environments |
| `sqlmesh invalidate <env>` | Force an environment to be fully rebuilt on next plan |
| `sqlmesh janitor` | Clean up old physical tables no longer referenced |
| `sqlmesh check_intervals <model>` | Show missing data intervals for a model |

## Utilities
| Command | Description |
|---------|-------------|
| `sqlmesh dag` | Render the model DAG as an HTML file |
| `sqlmesh table_name <model>` | Print the physical table name for a model |
| `sqlmesh create_external_models` | Auto-generate external model definitions from DB |
| `sqlmesh clean` | Clear SQLMesh cache and build artifacts |
| `sqlmesh destroy` | Remove all project resources (destructive) |

## Local Validation (no Snowflake connection required)

These commands validate your project locally without connecting to Snowflake.
Use them to catch issues before running `sqlmesh plan` against a live environment.

| Step | Command | What it checks |
|------|---------|----------------|
| 1 | `SNOWFLAKE_PASSWORD=dummy sqlmesh lint` | Linter rules: `owner`, `tags`, built-in audit, no `SELECT *`, no ambiguous columns. Fails fast on static errors. |
| 2 | `SNOWFLAKE_PASSWORD=dummy sqlmesh test` | Unit tests in `tests/*.yaml` — runs entirely in local DuckDB, no network call. |
| 3 | `SNOWFLAKE_PASSWORD=dummy sqlmesh plan --skip-backfill` | Parses all SQL with SQLGlot, computes the DAG diff against local state. Fails only when it tries to connect to Snowflake to check existing tables. |

> **Note:** A dummy password is used here purely to satisfy the config validation check at startup. Steps 1–2
> never open a Snowflake connection. Step 3 will fail at the apply stage but succeeds for the diff/preview output.

### What local validation does NOT cover
- Whether SQL functions (`INITCAP`, `GREATEST`, etc.) are supported in your Snowflake edition/region
- Whether your role has `CREATE DATABASE` / `CREATE SCHEMA` privileges for new targets
- Whether data types cast correctly in Snowflake vs. DuckDB

### Applying to Snowflake
Once local validation passes, apply with your real password:

```bash
# Apply to prod (interactive — shows diff and prompts for confirmation)
SNOWFLAKE_PASSWORD=<your_password> sqlmesh plan

# Apply without prompting
SNOWFLAKE_PASSWORD=<your_password> sqlmesh plan --auto-apply

# Target a dev environment first (creates isolated virtual tables)
SNOWFLAKE_PASSWORD=<your_password> sqlmesh plan dev
```

## Global Flags
| Flag | Description |
|------|-------------|
| `-p <path>` | Point to a different project directory |
| `--gateway <name>` | Use a specific gateway |
| `--var key=value` | Override a project variable |
| `--select-model <pattern>` | Run only matching models (e.g. `tag:critical`) |
| `--dotenv <path>` | Load a custom `.env` file |
| `--debug` | Enable verbose debug output |
