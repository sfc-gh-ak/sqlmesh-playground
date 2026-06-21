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

## Global Flags
| Flag | Description |
|------|-------------|
| `-p <path>` | Point to a different project directory |
| `--gateway <name>` | Use a specific gateway |
| `--var key=value` | Override a project variable |
| `--select-model <pattern>` | Run only matching models (e.g. `tag:critical`) |
| `--dotenv <path>` | Load a custom `.env` file |
| `--debug` | Enable verbose debug output |
