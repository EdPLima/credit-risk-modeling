"""Create report charts only from metrics recorded in the executed notebooks."""

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np


ASSETS = Path(__file__).resolve().parent / "assets"
NAVY, BLUE, TEAL, ORANGE, RED = "#102A43", "#1F5FAD", "#0F9D8A", "#E78938", "#C64444"
plt.rcParams.update({"font.family": "Arial", "font.size": 10})


def _finish(ax: plt.Axes) -> None:
    ax.grid(axis="y", color="#D9E2EC", linewidth=0.7)
    ax.spines[["top", "right", "left"]].set_visible(False)
    ax.tick_params(axis="y", length=0)


def lift_chart() -> None:
    """Show test-set risk concentration by score decile."""
    deciles = np.arange(1, 11)
    lift = np.array([3.653, 1.887, 1.299, 0.949, 0.659, 0.514, 0.397, 0.292, 0.216, 0.135])
    cumulative = np.array([3.653, 2.770, 2.280, 1.947, 1.689, 1.493, 1.337, 1.206, 1.096, 1.000])
    fig, ax = plt.subplots(figsize=(8.8, 4.7))
    bars = ax.bar(deciles, lift, width=0.66, color=[BLUE] + ["#A7C6ED"] * 9)
    ax.plot(deciles, cumulative, color=ORANGE, marker="o", linewidth=2.2, label="Lift acumulado")
    ax.axhline(1, color="#829AB1", linewidth=1, linestyle="--")
    ax.set_xticks(deciles)
    ax.set_xlabel("Decil de risco (1 = maior score)")
    ax.set_ylabel("Lift")
    ax.set_ylim(0, 4.2)
    ax.set_title("Concentração de inadimplência por decil de score", color=NAVY, fontsize=15, pad=16)
    for bar, value in zip(bars, lift):
        ax.text(bar.get_x() + bar.get_width() / 2, value + 0.10, f"{value:.2f}", ha="center", color=NAVY, fontsize=8)
    ax.legend(frameon=False, loc="upper right")
    _finish(ax)
    fig.tight_layout()
    fig.savefig(ASSETS / "lift-by-score-decile.png", dpi=200, bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    lift_chart()
