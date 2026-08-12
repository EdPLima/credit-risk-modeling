import numpy as np
import pandas as pd


MODEL_FEATURES = [
    "BENS_RENDA_RATIO",
    "LIMITE_TOTAL",
    "TOTAL_PARCELAS",
    "REG_CITY_NOT_LIVE_CITY",
    "CONTATOS_POR_CREDITO",
    "CNT_FAM_MEMBERS",
    "AMT_REQ_CREDIT_BUREAU_QRT",
    "FLAG_DOCUMENT_3",
    "AREA_CONSTRUIDA_TOTAL",
    "REGION_POPULATION_RELATIVE",
    "QUALIDADE_MORADIA",
    "HISTORICO_FINANCEIRO_TOTAL",
    "EXT_SOURCE_2",
    "ATRASO_POR_PARCELA",
    "ORGANIZATION_TYPE",
    "TEMPO_CADASTRO_ANOS",
    "DEF_30_CNT_SOCIAL_CIRCLE",
    "HISTORICO_MESES",
    "CREDITOS_POR_IDADE",
    "UTILIZACAO_LIMITE_BUREAU",
    "EXT_SOURCE_MAX",
    "PCT_CREDITOS_ATIVOS",
    "NAME_INCOME_TYPE",
    "DOCUMENTOS_POR_CREDITO",
    "NAME_FAMILY_STATUS",
    "FLAG_WORK_PHONE",
    "TEMPO_DOCUMENTO_ANOS",
    "PAGAMENTO_SALDO_RATIO",
    "CREDITO_NEGADO_TOTAL",
    "VALOR_CREDITO_TOTAL",
    "DIAS_CREDITO_MEDIO",
    "ATRASO_PAGAMENTO_MAX",
    "TOTAL_FLAGS_DOCUMENTOS",
    "TEMPO_CREDITO_POR_IDADE",
    "REGION_RATING_CLIENT_W_CITY",
    "DIVIDA_TOTAL",
    "CREDITO_APROVADO_RENDA",
    "SOLICITACOES_POR_EMPREGO",
    "CREDITO_ATIVO",
    "AMT_CREDIT",
    "TEMPO_EMPREGADO_ANOS",
    "VALOR_CREDITO_MEDIO_BUREAU",
    "OCCUPATION_TYPE",
    "SAQUE_LIMITE_RATIO",
    "VALOR_MEDIO_PARCELA",
    "ANUIDADE_MEDIA",
    "DIAS_DECISAO_MEDIO",
    "DPD_DEF_MEDIO_POS",
    "UTILIZACAO_CARTAO",
    "OWN_CAR_AGE",
    "EXT_SOURCE_COMPLT_SUM",
    "TAXA_APROVACAO_CREDITO",
    "DIVIDA_RENDA_RATIO",
    "ANUIDADE_HISTORICA_RATIO",
    "EXT_SOURCE_1",
    "NAME_EDUCATION_TYPE",
    "CREDITO_APROVADO_TOTAL",
    "TOTAL_POS",
    "VALOR_PAGO_TOTAL",
    "EXT_SOURCE_MIN",
    "CREDITO_VS_BEM_RATIO",
    "AMT_ANNUITY",
    "EXT_SOURCE_3",
    "IDADE_ANOS",
    "PCT_PAGAMENTO_REALIZADO",
    "AMT_GOODS_PRICE",
    "EXT_SOURCE_COMPLT_MEAN",
]

ENGINEERED_FEATURES = [
    "BENS_RENDA_RATIO",
    "COMPROMETIMENTO_RENDA_PCT",
    "CREDITO_RENDA_RATIO",
    "ANNUITY_RENDA_ANUAL",
    "CREDITO_VS_BEM_RATIO",
    "RENDA_DISPONIVEL",
    "IDADE_ANOS",
    "TEMPO_EMPREGADO_ANOS",
    "TEMPO_CADASTRO_ANOS",
    "TEMPO_DOCUMENTO_ANOS",
    "EXPERIENCIA_IDADE_RATIO",
    "RENDA_PER_CAPITA",
    "DEPENDENTES_POR_MEMBRO",
    "RENDA_POR_DEPENDENTE",
    "TOTAL_FLAGS_DOCUMENTOS",
    "TOTAL_CONTATOS_ATIVOS",
    "TOTAL_CONSULTAS_BUREAU",
    "CONSULTAS_ANO_NORMALIZADA",
    "MOBILIDADE_REGIONAL",
    "MOBILIDADE_CIDADE",
    "EXT_SOURCE_MIN",
    "EXT_SOURCE_MAX",
    "EXT_SOURCE_RANGE",
    "AREA_CONSTRUIDA_TOTAL",
    "QUALIDADE_MORADIA",
    "AREA_VIVA_RATIO",
    "PCT_CREDITOS_ATIVOS",
    "CREDITOS_POR_IDADE",
    "CONSULTAS_POR_CREDITO",
    "DIVIDA_RENDA_RATIO",
    "DIVIDA_CREDITO_RATIO",
    "DIVIDA_BEM_RATIO",
    "UTILIZACAO_LIMITE_BUREAU",
    "VALOR_CREDITO_MEDIO_BUREAU",
    "ATRASO_POR_CREDITO",
    "SOLICITACOES_POR_IDADE",
    "SOLICITACOES_POR_EMPREGO",
    "TAXA_APROVACAO_CREDITO",
    "CREDITO_NEGADO_TOTAL",
    "CREDITO_APROVADO_RENDA",
    "ANUIDADE_HISTORICA_RATIO",
    "DPD_DEF_MEDIO_POS",
    "UTILIZACAO_CARTAO",
    "PAGAMENTO_SALDO_RATIO",
    "SAQUE_LIMITE_RATIO",
    "SALDO_RENDA_RATIO",
    "CARTOES_POR_IDADE",
    "PCT_PAGAMENTO_REALIZADO",
    "CONTATOS_POR_CREDITO",
    "DOCUMENTOS_POR_CREDITO",
    "DIVIDA_PER_CAPITA",
    "VALOR_MEDIO_PARCELA",
    "ATRASO_POR_PARCELA",
    "TEMPO_CREDITO_POR_IDADE",
]


def _safe_divide(numerator, denominator):
    if denominator is None:
        return np.nan
    denominator = denominator.replace(0, np.nan)
    return numerator / denominator


def create_features(df):
    df = df.copy()

    document_cols = [
        "FLAG_DOCUMENT_2",
        "FLAG_DOCUMENT_3",
        "FLAG_DOCUMENT_4",
        "FLAG_DOCUMENT_5",
        "FLAG_DOCUMENT_6",
        "FLAG_DOCUMENT_7",
        "FLAG_DOCUMENT_8",
        "FLAG_DOCUMENT_9",
        "FLAG_DOCUMENT_10",
        "FLAG_DOCUMENT_11",
        "FLAG_DOCUMENT_12",
        "FLAG_DOCUMENT_13",
        "FLAG_DOCUMENT_14",
        "FLAG_DOCUMENT_15",
        "FLAG_DOCUMENT_16",
        "FLAG_DOCUMENT_17",
        "FLAG_DOCUMENT_18",
        "FLAG_DOCUMENT_19",
        "FLAG_DOCUMENT_20",
        "FLAG_DOCUMENT_21",
    ]

    contato_cols = [
        "FLAG_MOBILIZER",
        "FLAG_EMP_PHONE",
        "FLAG_WORK_PHONE",
        "FLAG_CONT_MOBILE",
    ]

    bureau_cols = [
        "AMT_REQ_CREDIT_BUREAU_HOUR",
        "AMT_REQ_CREDIT_BUREAU_DAY",
        "AMT_REQ_CREDIT_BUREAU_WEEK",
        "AMT_REQ_CREDIT_BUREAU_MON",
        "AMT_REQ_CREDIT_BUREAU_QRT",
        "AMT_REQ_CREDIT_BUREAU_YEAR",
    ]

    ext_cols = ["EXT_SOURCE_1", "EXT_SOURCE_2", "EXT_SOURCE_3"]

    df["BENS_RENDA_RATIO"] = _safe_divide(
        df["AMT_GOODS_PRICE"], df["AMT_INCOME_TOTAL"]
    )
    df["COMPROMETIMENTO_RENDA_PCT"] = _safe_divide(
        df["AMT_ANNUITY"], df["AMT_INCOME_TOTAL"]
    )
    df["CREDITO_RENDA_RATIO"] = _safe_divide(
        df["AMT_CREDIT"], df["AMT_INCOME_TOTAL"]
    )
    df["ANNUITY_RENDA_ANUAL"] = _safe_divide(
        df["AMT_ANNUITY"] * 12, df["AMT_INCOME_TOTAL"]
    )
    df["RENDA_DISPONIVEL"] = df["AMT_INCOME_TOTAL"] - df["AMT_ANNUITY"]
    df["IDADE_ANOS"] = df["DAYS_BIRTH"] / -365
    df["TEMPO_EMPREGADO_ANOS"] = df["DAYS_EMPLOYED"] / -365
    df["TEMPO_CADASTRO_ANOS"] = df["DAYS_REGISTRATION"] / -365
    df["TEMPO_DOCUMENTO_ANOS"] = df["DAYS_ID_PUBLISH"] / -365
    df["EXPERIENCIA_IDADE_RATIO"] = _safe_divide(
        df["TEMPO_EMPREGADO_ANOS"], df["IDADE_ANOS"]
    )
    df["RENDA_PER_CAPITA"] = _safe_divide(
        df["AMT_INCOME_TOTAL"], df["CNT_FAM_MEMBERS"]
    )
    df["DEPENDENTES_POR_MEMBRO"] = _safe_divide(
        df["CNT_CHILDREN"], df["CNT_FAM_MEMBERS"]
    )
    df["RENDA_POR_DEPENDENTE"] = _safe_divide(
        df["AMT_INCOME_TOTAL"], df["CNT_CHILDREN"] + 1
    )
    df["TOTAL_FLAGS_DOCUMENTOS"] = df[document_cols].sum(axis=1)
    df["TOTAL_CONTATOS_ATIVOS"] = df[contato_cols].sum(axis=1)
    df["TOTAL_CONSULTAS_BUREAU"] = df[bureau_cols].sum(axis=1)
    df["CONSULTAS_ANO_NORMALIZADA"] = _safe_divide(
        df["AMT_REQ_CREDIT_BUREAU_YEAR"], df["AMT_REQ_CREDIT_BUREAU_MON"] + 1
    )
    df["MOBILIDADE_REGIONAL"] = df[
        ["REG_REGION_NOT_LIVE_REGION", "REG_REGION_NOT_WORK_REGION", "LIVE_REGION_NOT_WORK_REGION"]
    ].max(axis=1)
    df["MOBILIDADE_CIDADE"] = df[
        ["REG_CITY_NOT_LIVE_CITY", "REG_CITY_NOT_WORK_CITY", "LIVE_CITY_NOT_WORK_CITY"]
    ].max(axis=1)
    df["EXT_SOURCE_MIN"] = df[ext_cols].min(axis=1)
    df["EXT_SOURCE_MAX"] = df[ext_cols].max(axis=1)
    df["EXT_SOURCE_RANGE"] = df["EXT_SOURCE_MAX"] - df["EXT_SOURCE_MIN"]
    df["AREA_CONSTRUIDA_TOTAL"] = (
        df["LIVINGAREA_AVG"].fillna(0)
        + df["TOTALAREA_MODE"].fillna(0)
        + df["APARTMENTS_AVG"].fillna(0)
    )
    df["QUALIDADE_MORADIA"] = (
        df["FLOORSMAX_AVG"].fillna(0)
        + df["ELEVATORS_AVG"].fillna(0)
        + df["YEARS_BEGINEXPLUATATION_AVG"].fillna(0)
    )
    df["AREA_VIVA_RATIO"] = _safe_divide(
        df["LIVINGAREA_AVG"], df["TOTALAREA_MODE"]
    )
    df["PCT_CREDITOS_ATIVOS"] = _safe_divide(
        df["CREDITO_ATIVO"], df["TOTAL_CREDITOS_BUREAU"]
    )
    df["CREDITOS_POR_IDADE"] = _safe_divide(
        df["TOTAL_CREDITOS_BUREAU"], df["IDADE_ANOS"]
    )
    df["CONSULTAS_POR_CREDITO"] = _safe_divide(
        df["CONSULTAS_BUREAU"], df["TOTAL_CREDITOS_BUREAU"]
    )
    df["DIVIDA_RENDA_RATIO"] = _safe_divide(
        df["DIVIDA_TOTAL"], df["AMT_INCOME_TOTAL"]
    )
    df["DIVIDA_CREDITO_RATIO"] = _safe_divide(
        df["DIVIDA_TOTAL"], df["AMT_CREDIT"]
    )
    df["DIVIDA_BEM_RATIO"] = _safe_divide(
        df["DIVIDA_TOTAL"], df["AMT_GOODS_PRICE"]
    )
    df["UTILIZACAO_LIMITE_BUREAU"] = _safe_divide(
        df["DIVIDA_TOTAL"], df["LIMITE_TOTAL"]
    )
    df["VALOR_CREDITO_MEDIO_BUREAU"] = _safe_divide(
        df["VALOR_CREDITO_TOTAL"], df["TOTAL_CREDITOS_BUREAU"]
    )
    df["ATRASO_POR_CREDITO"] = _safe_divide(
        df["ATRASO_MAXIMO"], df["TOTAL_CREDITOS_BUREAU"]
    )
    df["SOLICITACOES_POR_IDADE"] = _safe_divide(
        df["TOTAL_SOLICITACOES"], df["IDADE_ANOS"]
    )
    df["SOLICITACOES_POR_EMPREGO"] = _safe_divide(
        df["TOTAL_SOLICITACOES"], df["TEMPO_EMPREGADO_ANOS"]
    )
    df["TAXA_APROVACAO_CREDITO"] = _safe_divide(
        df["CREDITO_APROVADO_TOTAL"], df["CREDITO_SOLICITADO_TOTAL"]
    )
    df["CREDITO_NEGADO_TOTAL"] = (
        df["CREDITO_SOLICITADO_TOTAL"] - df["CREDITO_APROVADO_TOTAL"]
    )
    df["CREDITO_APROVADO_RENDA"] = _safe_divide(
        df["CREDITO_APROVADO_TOTAL"], df["AMT_INCOME_TOTAL"]
    )
    df["ANUIDADE_HISTORICA_RATIO"] = _safe_divide(
        df["ANUIDADE_MEDIA"], df["AMT_ANNUITY"]
    )
    df["DPD_DEF_MEDIO_POS"] = _safe_divide(
        df["DPD_DEF_MAX"], df["TOTAL_POS"]
    )
    df["UTILIZACAO_CARTAO"] = _safe_divide(
        df["SALDO_TOTAL"], df["LIMITE_CARTAO_TOTAL"]
    )
    df["PAGAMENTO_SALDO_RATIO"] = _safe_divide(
        df["PAGAMENTO_TOTAL"], df["SALDO_TOTAL"]
    )
    df["SAQUE_LIMITE_RATIO"] = _safe_divide(
        df["SAQUE_TOTAL"], df["LIMITE_CARTAO_TOTAL"]
    )
    df["SALDO_RENDA_RATIO"] = _safe_divide(
        df["SALDO_TOTAL"], df["AMT_INCOME_TOTAL"]
    )
    df["CARTOES_POR_IDADE"] = _safe_divide(
        df["TOTAL_CARTOES"], df["IDADE_ANOS"]
    )
    df["PCT_PAGAMENTO_REALIZADO"] = _safe_divide(
        df["VALOR_PAGO_TOTAL"], df["VALOR_PARCELAS_TOTAL"]
    )
    df["CONTATOS_POR_CREDITO"] = _safe_divide(
        df["TOTAL_CONTATOS_ATIVOS"], df["TOTAL_CREDITOS_BUREAU"]
    )
    df["DOCUMENTOS_POR_CREDITO"] = _safe_divide(
        df["TOTAL_FLAGS_DOCUMENTOS"], df["TOTAL_CREDITOS_BUREAU"]
    )
    df["DIVIDA_PER_CAPITA"] = _safe_divide(
        df["DIVIDA_TOTAL"], df["RENDA_PER_CAPITA"]
    )
    df["VALOR_MEDIO_PARCELA"] = _safe_divide(
        df["VALOR_PARCELAS_TOTAL"], df["TOTAL_PARCELAS"]
    )
    df["ATRASO_POR_PARCELA"] = _safe_divide(
        df["ATRASO_PAGAMENTO_MAX"], df["TOTAL_PARCELAS"]
    )
    df["TEMPO_CREDITO_POR_IDADE"] = _safe_divide(
        df["DAYS_CREDIT"], df["IDADE_ANOS"]
    )
    df["CREDITO_VS_BEM_RATIO"] = _safe_divide(
        df["AMT_CREDIT"], df["AMT_GOODS_PRICE"]
    )

    return df


def selection_features(df):
    df = create_features(df)
    return df.reindex(columns=MODEL_FEATURES)
