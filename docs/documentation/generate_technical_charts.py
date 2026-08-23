"""Create static charts used by the Portuguese technical documentation.

Values come from the recorded outputs of the executed project notebooks.
Re-run this file after a new model evaluation.
"""

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np

ASSETS_DIR = Path(__file__).resolve().parent / "assets"
ASSETS_DIR.mkdir(parents=True, exist_ok=True)

NAVY = "#102A43"
BLUE = "#2F80ED"
TEAL = "#00A6A6"
ORANGE = "#F2994A"
RED = "#D64545"

plt.rcParams.update({"font.family": "Arial", "font.size": 11})


def finish(ax: plt.Axes) -> None:
    """Apply the shared visual language."""
    ax.grid(axis="y", alpha=0.18)
    ax.spines[["top", "right", "left"]].set_visible(False)
    ax.tick_params(axis="y", length=0)


def brl(value: float) -> str:
    return f"R$ {value:,.0f}".replace(",", "X").replace(".", ",").replace("X", ".")


def target_imbalance() -> None:
    labels, values = ["Adimplente", "Inadimplente"], [91.93, 8.07]
    fig, ax = plt.subplots(figsize=(8, 4.2))
    bars = ax.bar(labels, values, color=[TEAL, ORANGE], width=0.56)
    ax.set_ylim(0, 105)
    ax.set_ylabel("Participação na base (%)")
    ax.set_title("Distribuição do alvo", color=NAVY, fontsize=16, pad=16)
    finish(ax)
    for bar, value in zip(bars, values):
        ax.text(bar.get_x() + bar.get_width() / 2, value + 3, f"{value:.2f}%", ha="center", color=NAVY, fontsize=12)
    fig.tight_layout()
    fig.savefig(ASSETS_DIR / "target-imbalance.png", dpi=180, bbox_inches="tight")
    plt.close(fig)


def model_comparison() -> None:
    metrics = ["PR-AUC", "ROC-AUC", "KS"]
    logistic = [0.2415, 0.7569, 0.3867]
    lightgbm = [0.2790, 0.7801, 0.4168]
    x = np.arange(len(metrics))
    fig, ax = plt.subplots(figsize=(8, 4.5))
    width = 0.34
    baseline = ax.bar(x - width / 2, logistic, width, label="Regressão logística", color="#9BBBD4")
    champion = ax.bar(x + width / 2, lightgbm, width, label="LightGBM campeão", color=BLUE)
    ax.set_xticks(x, metrics)
    ax.set_ylim(0, 0.9)
    ax.set_ylabel("Valor da métrica")
    ax.set_title("Comparação no conjunto de teste", color=NAVY, fontsize=16, pad=16)
    ax.legend(frameon=False, loc="upper left")
    finish(ax)
    for bars in (baseline, champion):
        for bar in bars:
            ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.02, f"{bar.get_height():.3f}", ha="center", fontsize=9, color=NAVY)
    fig.tight_layout()
    fig.savefig(ASSETS_DIR / "model-comparison.png", dpi=180, bbox_inches="tight")
    plt.close(fig)


def financial_impact() -> None:
    labels = ["Inadimplência\ndetectada", "Falsos\nalertas", "Inadimplência\nnão detectada"]
    values = [1_165_308_642, 3_356_049_447, 1_610_049_074]
    fig, ax = plt.subplots(figsize=(8, 4.5))
    bars = ax.bar(labels, np.array(values) / 1e9, color=[TEAL, ORANGE, RED], width=0.56)
    ax.set_ylabel("Valor de crédito (R$ bilhões)")
    ax.set_title("Impacto financeiro no conjunto de teste", color=NAVY, fontsize=16, pad=16)
    finish(ax)
    for bar, value in zip(bars, values):
        ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.10, brl(value), ha="center", fontsize=9, color=NAVY)
    fig.tight_layout()
    fig.savefig(ASSETS_DIR / "financial-impact.png", dpi=180, bbox_inches="tight")
    plt.close(fig)


def threshold_tradeoff() -> None:
    threshold = np.array([0.55, 0.60, 0.65, 0.70, 0.75])
    recall = np.array([0.6045, 0.5358, 0.4600, 0.3719, 0.2888])
    precision = np.array([0.2040, 0.2240, 0.2491, 0.2764, 0.3075])
    captured = np.array([57.73, 49.63, 41.96, 33.68, 25.95])
    fig, ax = plt.subplots(figsize=(8, 4.5))
    ax.plot(threshold, recall, marker="o", color=TEAL, label="Recall")
    ax.plot(threshold, precision, marker="o", color=ORANGE, label="Precisão")
    ax2 = ax.twinx()
    ax2.plot(threshold, captured, marker="o", color=BLUE, linestyle="--", label="Valor capturado")
    ax.axvline(0.65, color="#52606D", linestyle=":", linewidth=1.5)
    ax.set_xlabel("Threshold")
    ax.set_ylabel("Precisão / Recall")
    ax2.set_ylabel("Valor inadimplente capturado (%)")
    ax.set_ylim(0, 0.75)
    ax2.set_ylim(0, 70)
    ax.set_title("Trade-off definido na validação", color=NAVY, fontsize=16, pad=16)
    ax.grid(axis="y", alpha=0.18)
    ax.spines[["top", "left"]].set_visible(False)
    ax2.spines[["top", "right"]].set_visible(False)
    lines = ax.get_lines() + ax2.get_lines()
    ax.legend(lines, [line.get_label() for line in lines], frameon=False, loc="center left")
    fig.tight_layout()
    fig.savefig(ASSETS_DIR / "threshold-tradeoff.png", dpi=180, bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    target_imbalance()
    model_comparison()
    financial_impact()
    threshold_tradeoff()
