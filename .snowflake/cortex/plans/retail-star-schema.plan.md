# Plan: RAW layer — source system simulation

## Scope

This phase only covers the RAW layer. ODS and STAR are out of scope for now.

```
seeds/raw/*.csv  →  SEED models  →  STAR_SIMULATOR_DB.RAW.*
```

---

## Context

- [config.py](config.py) routes models to Snowflake via 3-part names (`db.schema.table`) — no extra config needed beyond adding a `star_db` variable for documentation/reuse.
- The active linter blocks `sqlmesh plan` unless every model declares `owner`, an approved `tag`, and at least one built-in audit. All new SEED models must comply.
- Seed data covers **2025-07-01 → 2025-12-31** (6 months).

---

## Implementation steps

### Step 1 — Update `config.py`

Add a `star_db` variable:

```python
variables={
    ...existing...,
    "star_db": "STAR_SIMULATOR_DB",
}
```

---

### Step 2 — Create seed CSV files

Location: `seeds/raw/` (new subdirectory)

| File | Rows | Key fields |
|---|---|---|
| `raw_orders.csv` | ~200 | order_id, customer_id, store_id, promo_id, channel, status, order_date, updated_at |
| `raw_order_items.csv` | ~500 | item_id, order_id, product_id, quantity, unit_price, discount_amount |
| `raw_customers.csv` | ~80 | customer_id, first_name, last_name, email, city, state, country, signup_date, tier |
| `raw_products.csv` | ~40 | product_id, sku, name, category_id, brand, cost, list_price, is_active |
| `raw_categories.csv` | ~12 | category_id, name, parent_category_id, department |
| `raw_stores.csv` | ~10 | store_id, name, city, state, country, store_type, opened_date |
| `raw_promotions.csv` | ~8 | promo_id, name, discount_type, discount_value, start_date, end_date |
| `raw_returns.csv` | ~30 | return_id, order_id, item_id, reason, return_date, refund_amount |
| `raw_inventory.csv` | ~300 | snapshot_date, product_id, store_id, qty_on_hand, qty_reserved |

Data is consistent — FKs in `raw_order_items` reference valid `order_id` values in `raw_orders`, `product_id` values exist in `raw_products`, etc.

---

### Step 3 — Create RAW SEED models

Location: `models/raw/` (new subdirectory, 9 files)

Model naming: `star_simulator_db.raw.<table_name>`

Each model follows this pattern:

```sql
MODEL (
  name star_simulator_db.raw.raw_orders,
  kind SEED (path '../../seeds/raw/raw_orders.csv'),
  owner 'data_team',
  tags ['standard'],
  description 'Source system extract: order headers. Simulates operational DB CDC output.',
  columns (
    order_id     INTEGER,
    customer_id  INTEGER,
    store_id     INTEGER,
    promo_id     INTEGER,
    channel      VARCHAR,
    status       VARCHAR,
    order_date   DATE,
    updated_at   TIMESTAMP
  ),
  grain (order_id),
  audits (not_null(columns := [order_id, customer_id, order_date]))
);
```

The `columns` block is required for SEED models (SQLMesh uses it to validate the CSV). Each model's `grain` and `not_null` columns are chosen to match the natural key of that entity.

---

## File layout after this phase

```
config.py                       (star_db variable added)
seeds/
  raw/
    raw_orders.csv
    raw_order_items.csv
    raw_customers.csv
    raw_products.csv
    raw_categories.csv
    raw_stores.csv
    raw_promotions.csv
    raw_returns.csv
    raw_inventory.csv
models/
  raw/
    raw_orders.sql
    raw_order_items.sql
    raw_customers.sql
    raw_products.sql
    raw_categories.sql
    raw_stores.sql
    raw_promotions.sql
    raw_returns.sql
    raw_inventory.sql
```

---

## Verification

```bash
# Lint — all 9 new models must pass with no errors
sqlmesh lint

# Dry-run plan — review what SQLMesh intends to CREATE in STAR_SIMULATOR_DB.RAW
sqlmesh plan --no-prompts

# Apply to Snowflake (creates STAR_SIMULATOR_DB if it doesn't exist, then loads all seeds)
sqlmesh plan
```

---

## Critical files

- [config.py](config.py) — minor update, add `star_db` variable
- `models/raw/*.sql` — 9 SEED models, must satisfy linter rules
- `seeds/raw/*.csv` — 9 CSV files with referentially consistent fake data
