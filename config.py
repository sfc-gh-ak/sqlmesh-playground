import os
from sqlmesh.core.config import (
    Config,
    ModelDefaultsConfig,
    GatewayConfig,
    LinterConfig,
)
from sqlmesh.core.config.connection import SnowflakeConnectionConfig
from sqlmesh.core.config.connection import DuckDBConnectionConfig

# --- Gateway Connection ---
# https://sqlmesh.readthedocs.io/en/stable/integrations/engines/snowflake/

config = Config(
    gateways={
        "snowflake": GatewayConfig(
            connection=SnowflakeConnectionConfig(
                account="sfpscogs-akm_strawberry",
                user="strawberry",
                password=os.environ.get("SNOWFLAKE_PASSWORD"),
                warehouse="strawberry_wh",
                database="strawberry_db",
                role="sysadmin",
                authenticator="snowflake",
            ),
            # State stored in local DuckDB (Snowflake not recommended for state)
            state_connection=DuckDBConnectionConfig(database="snowflake_state.db"),
            # Uncomment to use Snowflake Postgres for shared/team state:
            # state_connection=PostgresConnectionConfig(
            #     host="5522uzgc2bae5hc75pbmgs24gm.sfpscogs-akm-strawberry.us-west-2.aws.postgres.snowflake.app",
            #     user="snowflake_admin",
            #     password=os.environ.get("PGPASSWORD", ""),
            #     database="postgres",
            #     port=5432,
            # ),
        )
    },
    default_gateway="snowflake",

    # --- Model Defaults ---
    # https://sqlmesh.readthedocs.io/en/stable/reference/model_configuration/#model-defaults
    model_defaults=ModelDefaultsConfig(
        dialect="snowflake",
        start="2026-05-22",  # start date for backfill history
        cron="@daily",       # run models daily at 12am UTC (can override per model)
    ),

    # --- Global Variables ---
    # Reference in models with @VAR('name'), override at runtime with --var key=value
    # https://sqlmesh.readthedocs.io/en/stable/concepts/macros/macro_variables/
    variables={
        "gw_db": os.environ.get("SNOWFLAKE_DB", "STRAWBERRY_DB"),       # main execution database
        "raw_db": os.environ.get("SNOWFLAKE_RAW_DB", "STRAWBERRY_DB"),  # source/raw data database
        "reporting_schema": "ANALYTICS",                                  # schema for analyst-facing models
        "environment": os.environ.get("SQLMESH_ENV", "prod"),            # override with SQLMESH_ENV=dev
        "star_db": "STAR_SIMULATOR_DB",                                    # star schema simulator database
    },

    # --- Linting Rules ---
    # https://sqlmesh.readthedocs.io/en/stable/guides/linter/
    linter=LinterConfig(
        enabled=True,
        # ERROR: these block sqlmesh plan from running
        rules=[
            "ambiguousorinvalidcolumn",   # built-in: flags duplicate/invalid column refs
            "invalidselectstarexpansion", # built-in: flags SELECT * that can't be expanded
            "noselectstar",               # built-in: blocks SELECT * in outer query
            "nomissingaudits",            # built-in: every model must have at least one audit
            "nomissingowner",             # custom (linter/user.py): model must declare owner
            "requireapprovedtag",         # custom (linter/user.py): model must have an approved tag
            "requirebuiltinaudit",        # custom (linter/user.py): model must use a built-in audit
        ],
        # WARN: these log a warning but don't block
        warn_rules=[
            "requiredescription",         # custom (linter/user.py): model should have description
            "criticalmodelsrequireaudits",# custom (linter/user.py): tag:critical → not_null + unique_values
            "piimodelsrequireowner",      # custom (linter/user.py): tag:pii → owner must be set
            "financemodelsrequiregrain",  # custom (linter/user.py): tag:finance → grain must be declared
        ],
    ),
)
