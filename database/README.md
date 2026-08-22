# Monitoring database

`migrations/001_monitoring_star_schema.sql` creates the `monitoring` schema
used by the Airflow pipelines and Power BI. It is separate from MLflow tables,
but can initially use the same PostgreSQL database in this portfolio project.

Apply it once after PostgreSQL is running:

```powershell
Get-Content database/migrations/001_monitoring_star_schema.sql |
    docker compose exec -T postgres psql -U $env:POSTGRES_USER -d $env:POSTGRES_DB
```

For the local `.env` values used by this repository, this is equivalent to:

```powershell
Get-Content database/migrations/001_monitoring_star_schema.sql |
    docker compose exec -T postgres psql -U mlflow -d mlflow
```

Do not place this migration in `docker-entrypoint-initdb.d`: PostgreSQL runs
those scripts only when its volume is first created, so existing environments
would silently miss the schema.

## Rule configuration examples

Rules are stored in `monitoring.dim_validation_rule`. `rule_config` keeps the
policy explicit and versioned without adding a database column per rule type.

| Rule type | Example `rule_config` |
| --- | --- |
| `range` | `{"min": 0, "max": 10000000}` |
| `regex` | `{"pattern": "^[A-Z_]+$"}` |
| `allowed_values` | `{"values": ["Cash loans", "Revolving loans"]}` |
| `feature_relationship` | `{"operator": "<=", "null_policy": "ignore"}` |
| `directional_expectation` | `{"expected_direction": "increasing", "outcome": "probability_default", "method": "spearman"}` |

Directional expectations are not seeded automatically. In credit risk, their
direction must be approved by business and risk teams; an association observed
in data is not enough to define a decision rule.
