# Credit Risk Modeling

An end-to-end machine learning project for estimating the probability of credit default in a batch-scoring setting. The project combines exploratory analysis, feature engineering, model selection, experiment tracking, model registration, and reproducible local infrastructure.

The focus is not only model performance. The workflow keeps train, validation, and test responsibilities separate, evaluates business impact in monetary terms, and packages the selected model with a clear prediction contract.

![Credit risk machine learning workflow](docs/images/credit-risk-workflow.png)

## What this project answers

### Notebook 01: Exploratory Data Analysis and Feature Engineering

The first notebook investigates data quality, risk patterns, and candidate features before modeling. The following findings come from the notebook outputs and are descriptive, not causal.

| Question | Observed result | Modeling implication |
| --- | --- | --- |
| How imbalanced is the target? | The dataset contains 307,511 applications and a default rate of 8.07%. | Accuracy alone would be misleading; PR-AUC, recall, KS, and class weighting are more informative. |
| Is missingness informative? | Several housing and external-score variables have substantial missingness. For example, `BASEMENTAREA_MEDI` is missing in 58.52% of rows and `EXT_SOURCE_1` in 56.38%. | Missingness indicators are assessed alongside imputation rather than treating all missing values as equivalent. |
| Does contract type relate to observed default? | Cash loans show an 8.35% default rate, compared with 5.48% for revolving loans. The exploratory odds ratio is approximately 1.57. | Contract type is a candidate feature, but the association is not interpreted as causal. |
| Is there an observed difference by gender? | The notebook reports default odds approximately 1.50 times higher for male applicants than for female applicants. | This is a monitoring and fairness-review signal, not a basis for a credit decision rule. |
| Do financial outliers have higher observed risk? | Isolation Forest outliers show a 6.19% default rate, lower than the 8.42% rate reported for the remaining portfolio. | Financial atypicality alone is not treated as a proxy for higher credit risk. |
| Is the target stable across data splits? | Default rates are 8.0729% in training, 8.0728% in validation, and 8.0728% in test. | Stratification preserved the event rate across partitions. |

The notebook also engineers domain-oriented financial features, removes constant variables, prunes highly correlated features, and evaluates candidate variables with Information Value (IV), Weight of Evidence (WoE), univariate KS, chi-square testing, and Cramér's V.

### Notebook 02: Modeling and Business Analysis

The second notebook turns the prepared data into a modeling workflow. It answers:

- Which candidate model best separates default from non-default applications? LightGBM is selected using cross-validation and PR-AUC as the primary selection metric.
- Does Optuna tuning improve the manually configured LightGBM baseline? In this experiment, the manual configuration generalized better on validation and was retained.
- Which decision threshold offers the best validation trade-off? The threshold is selected on validation data, not on the test set.
- Does the model concentrate risk in the highest-scored accounts? The top risk decile reaches a lift of roughly 3.6 versus the portfolio average.
- Does the model capture material financial exposure, rather than only small loans? The analysis measures captured and missed default exposure using `AMT_CREDIT`.

The test set is reserved for one final assessment after model and threshold decisions are frozen.

## Workflow

```text
Raw credit data
    -> EDA and feature engineering
    -> Stratified train / validation / test datasets
    -> Feature selection and cross-validation
    -> Hyperparameter and threshold selection on validation
    -> One-time test evaluation
    -> MLflow artifacts and Model Registry
    -> Batch scoring with models:/credit-risk-model@champion
```

## Dataset preparation

`00_PREP_DATA.ipynb` builds the analytical dataset used by the following
notebooks. It expects these CSV files under `data/raw/`:

| File | Granularity | How it is used |
| --- | --- | --- |
| `application_train.csv` | One current credit application per customer (`SK_ID_CURR`) | Base table and source of `TARGET`. |
| `bureau.csv` | Previous external-credit record | Aggregated per customer. |
| `bureau_balance.csv` | Monthly history of an external-credit record (`SK_ID_BUREAU`) | Aggregated per bureau record, then joined to `bureau.csv`. |
| `previous_application.csv` | Previous internal credit application | Aggregated per customer. |
| `POS_CASH_balance.csv` | Monthly POS/cash-loan balance | Aggregated per customer. |
| `credit_card_balance.csv` | Monthly credit-card balance | Aggregated per customer. |
| `installments_payments.csv` | Installment-payment record | Aggregated per customer. |

The preparation logic deliberately aggregates one-to-many tables before
joining them. `bureau_balance.csv` is first summarized by `SK_ID_BUREAU` and
merged into `bureau.csv`. The resulting bureau information and every other
auxiliary dataset are then summarized by `SK_ID_CURR` and left-joined to
`application_train.csv`.

```text
bureau_balance -- aggregate by SK_ID_BUREAU --> bureau -- aggregate by SK_ID_CURR --+
                                                                                     |
previous_application -- aggregate by SK_ID_CURR -------------------------------------+
POS_CASH_balance ----- aggregate by SK_ID_CURR --------------------------------------+--> application_train
credit_card_balance -- aggregate by SK_ID_CURR --------------------------------------+
installments_payments - aggregate by SK_ID_CURR -------------------------------------+
```

This preserves one row per current application and avoids multiplying rows
during joins. The output is written to `data/raw/conjunto_completo.csv` and
is the input of `01_EDA-FE.ipynb`. Do not manually create this file; generate
it by running notebook 00.

> **Feature note:** `ATRASO_PAGAMENTO_MAX` is currently calculated from
> `DAYS_ENTRY_PAYMENT`, which represents the relative payment date rather
> than a payment-delay duration. Before production use, this feature should
> be replaced by an explicit delay calculation, such as
> `DAYS_ENTRY_PAYMENT - DAYS_INSTALMENT`, with its business sign convention
> validated.

## Repository structure

```text
.
├── data/
│   ├── raw/                 # Source datasets (not versioned)
│   └── interim/             # Train, validation, and test parquet files
├── docker/
│   └── Dockerfile.mlflow    # MLflow server image
├── notebooks/
│   ├── 00_PREP_DATA.ipynb
│   ├── 01_EDA-FE.ipynb
│   └── 02_PROCESSING_TRAING_MODEL.ipynb
├── src/
│   ├── config/              # Data, model, and MLflow configuration
│   ├── features/
│   ├── models/
│   └── pipeline/
│       ├── inference/
│       └── training/
├── tests/
├── docker-compose.yml
├── pyproject.toml
├── uv.lock                 # Exact, reproducible dependency resolution
└── .env                    # Local Docker credentials (ignored by Git)
```

## Prerequisites

- Python 3.10 through 3.12 (the project is locked with Python 3.12)
- [uv](https://docs.astral.sh/uv/) for Python dependency management
- VS Code with the Python and Jupyter extensions
- Docker Desktop with Docker Compose
- Raw input files placed under `data/raw/`

## Local setup

### 1. Configure local credentials

The Compose file reads database credentials from `.env`. The file is ignored by Git and must not be committed. Edit it and set a local password:

```dotenv
POSTGRES_DB=mlflow
POSTGRES_USER=mlflow
POSTGRES_PASSWORD=your-local-url-safe-password
```

Use a URL-safe password for local development because it is inserted into the PostgreSQL connection URI. If a password contains characters such as `@`, `:`, `/`, or `#`, it must be URL-encoded.

### 2. Install Python dependencies

```powershell
uv sync
```

This creates `.venv` and installs the exact versions recorded in `uv.lock`,
including the development tools. To run a command without activating the
environment, use `uv run`, for example `uv run pytest`.

### 3. Start MLflow and PostgreSQL

```powershell
docker compose up -d --build
docker compose ps
```

Open MLflow at [http://localhost:5000](http://localhost:5000).

The stack contains:

- PostgreSQL for MLflow metadata and Model Registry records;
- MLflow Tracking Server for experiments, runs, artifacts, and registered models;
- Docker volumes for persistent metadata and artifacts.

Do not run `docker compose down -v` unless you intentionally want to remove local MLflow history and artifacts.

### 4. Run the notebooks

Open the cloned repository folder in VS Code. Select the Python interpreter
from `.venv` when VS Code prompts for a kernel, then run notebooks in order:

1. `00_PREP_DATA.ipynb`
2. `01_EDA-FE.ipynb`
3. `02_PROCESSING_TRAING_MODEL.ipynb`

The final modeling workflow logs metrics, feature importance, SHAP plots, threshold metadata, input/output examples, and the model signature to MLflow.

## MLflow configuration

[`src/config/mlflow_config.yml`](src/config/mlflow_config.yml) defines the local tracking endpoint and the model reference used by inference:

```yaml
mlflow:
  tracking_uri: "http://localhost:5000"
  registered_model_name: "credit-risk-model"
  alias: "champion"
```

Batch inference should load the model through its alias rather than a fixed version:

```text
models:/credit-risk-model@champion
```

This allows a validated model version to be promoted or rolled back without changing inference code.

## Model contract

The registered batch model accepts the 67 selected raw features and returns:

| Output | Description |
| --- | --- |
| `probability_default` | Estimated probability of default. |
| `default_prediction` | Binary decision using the threshold selected on validation data. |

Each registered model version includes the following artifacts:

- classification report and confusion matrix;
- gain- and split-based feature importance;
- SHAP summary and SHAP feature-importance plots;
- selected feature list, threshold metadata, model signature, and input/output examples.

## Proposed batch inference and monitoring architecture

The target operating mode is batch scoring. The components below describe the
intended architecture; the Airflow DAGs and monitoring tables are not yet
implemented in this repository.

![Proposed batch inference architecture](docs/images/batch-inference-architecture.png)

```text
Incoming batch
    -> schema and data-quality validation
    -> load models:/credit-risk-model@champion from MLflow
    -> reuse the registered preprocessing and feature contract
    -> score applications
    -> persist predictions and monitoring aggregates in PostgreSQL
    -> refresh Power BI semantic model and dashboards
```

Airflow can schedule and observe this workflow, while reusable code in
`src/pipeline/inference/` performs the actual loading, preprocessing, and
scoring. DAG files should orchestrate tasks only; they should not contain
feature engineering or model logic.

Each batch must record the model version, model alias at scoring time, scoring
timestamp, batch identifier, selected input features, predicted probability,
decision threshold, and binary decision. That creates a reproducible audit
trail: a prediction can always be traced to the exact registered model version
that produced it.

### Monitoring metrics

Monitoring must distinguish data quality, drift, prediction behavior, and
model performance. Performance metrics require delayed ground-truth labels;
they cannot be calculated at scoring time.

| Monitoring area | Examples | Purpose |
| --- | --- | --- |
| Data quality | batch volume, duplicate records, missing required columns, type/range violations, missingness rate | Detect broken or incomplete source deliveries. |
| Feature drift | Population Stability Index (PSI), missingness-rate change, numeric quantile shifts, unseen categorical values | Detect whether model inputs differ from the training reference population. |
| Prediction drift | score-distribution PSI, mean predicted default probability, approval/alert rate, threshold crossing rate | Detect changes in model output before labels arrive. |
| Performance and calibration | PR-AUC, ROC-AUC, KS, precision, recall, F1, Brier score, calibration curve, captured financial exposure | Confirm predictive value once observed defaults are available. |
| Business segmentation | metrics by credit-value band, contract type, portfolio segment, and time period | Identify where the model captures or misses financial risk. |

PSI alert limits should be treated as operational starting points, not universal
rules: below 0.10 is commonly treated as stable, 0.10 to 0.25 as a signal to
investigate, and above 0.25 as material drift. Final thresholds should be
calibrated to portfolio volatility and business tolerance.

### PostgreSQL model for Power BI

Power BI should consume curated monitoring tables rather than raw source files.
A star schema is a better fit than putting every field and metric into one
wide fact table.

```text
dim_calendar ───────────────┐
dim_model ──────────────────┼── fact_scoring_batch
dim_segment (optional) ─────┘

dim_calendar ───────────────┐
dim_model ──────────────────┼── fact_feature_drift
dim_feature ────────────────┘

dim_calendar ───────────────┐
dim_model ──────────────────┼── fact_model_performance
dim_segment (optional) ─────┘
```

| Table | Grain and recommended content |
| --- | --- |
| `dim_model` | One row per registered model version: surrogate key, model name, MLflow version, run ID, model URI, threshold, training window, registration time, and lifecycle status. |
| `dim_calendar` | One row per date, with day, week, month, quarter, and year attributes for consistent Power BI time intelligence. |
| `dim_feature` | One row per monitored feature: name, type, source, selected-feature flag, expected range/category policy, and training-reference metadata. |
| `dim_segment` *(optional)* | Portfolio grouping such as contract type, credit-value band, channel, or business region. |
| `fact_scoring_batch` | One row per scored application: batch ID, scoring timestamp, model key, anonymized application key, probability, threshold, binary prediction, and later the observed target when available. |
| `fact_feature_drift` | One row per batch, model, feature, and segment: PSI, missingness rate, reference/current quantiles or category share, unseen-category rate, alert status, and calculation timestamp. |
| `fact_model_performance` | One row per evaluation period, model, and segment: labeled population size, event rate, PR-AUC, ROC-AUC, KS, precision, recall, F1, Brier score, and captured financial value. |

Avoid storing every raw input variable directly in the Power BI fact table.
If record-level traceability is required, keep the 67 selected inputs and
prediction in a restricted audit or staging table. The star schema should hold
prediction measures and feature-level aggregates so dashboards remain fast,
safe, and easy to model.

## Proposed Airflow retraining workflow

Retraining should be scheduled and may also be triggered by material data
drift, performance degradation after labels arrive, or a portfolio/business
change. A proposed DAG is:

![Proposed retraining architecture](docs/images/retraining-architecture.png)

```text
Ingest new labeled data
    -> validate schema, quality, and data window
    -> preprocess and engineer features
    -> train and tune candidate on training/validation data
    -> evaluate candidate and current champion on the same fresh out-of-time test set
    -> log comparison, artifacts, and validation gates to MLflow
    -> register candidate model version
    -> promote or retain champion
```

The comparison criteria must be declared before execution. PR-AUC can remain
the primary metric, protected by guardrails such as calibration, KS, minimum
recall, financial capture, and no material fairness or data-quality failure.
The test set is used only once after candidate decisions are frozen; each
retraining cycle needs a newly defined, time-appropriate holdout set.

If the candidate passes every gate and improves on the current champion, the
DAG moves the `champion` alias to the candidate version. The previous version
is preserved in the registry and receives tags such as
`lifecycle_status=archived`, `archived_at`, and `superseded_by_version`.
If the candidate does not pass, its version remains registered for
traceability, marked as rejected, and the `champion` alias does not move.

This gives inference a stable URI, `models:/credit-risk-model@champion`,
while preserving model history and allowing a controlled rollback.

## Useful commands

```powershell
# Follow MLflow logs
docker compose logs -f mlflow

# Follow PostgreSQL logs
docker compose logs -f postgres

# Stop services while preserving volumes
docker compose down

# Run tests
uv run pytest
```
