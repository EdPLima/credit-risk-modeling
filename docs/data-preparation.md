# Dataset Preparation

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

The preparation workflow aggregates one-to-many tables before joining them.
`bureau_balance.csv` is summarized by `SK_ID_BUREAU` and merged into
`bureau.csv`. The resulting bureau information and every other auxiliary
dataset are summarized by `SK_ID_CURR` and left-joined to
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
becomes the input to `01_EDA-FE.ipynb`. Generate it by running notebook 00;
do not create it manually.

## Feature implementation note

`ATRASO_PAGAMENTO_MAX` is currently calculated from `DAYS_ENTRY_PAYMENT`,
which represents a relative payment date rather than a payment-delay duration.
Before production use, replace it with an explicit delay calculation, such as
`DAYS_ENTRY_PAYMENT - DAYS_INSTALMENT`, after validating the business sign
convention.
