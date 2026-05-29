# ml/ - Machine Learning Detection Scripts

This folder contains the bespoke Python machine learning detection
component of the project. It complements the built-in OpenSearch
Anomaly Detection plugin (configured through OpenSearch Dashboards)
and is intentionally separate so that the algorithm itself, its
parameters, and its design choices are auditable in code rather than
hidden in a vendor UI.

## Files

| File | What it does |
|---|---|
| `isolation_forest_siem.py` | Full pipeline that reads an OpenSearch JSON export, builds behavioural feature windows per source IP and time window, fits a scikit-learn Isolation Forest, scores every window, evaluates against ground truth (the attacker source IP), and writes results, figures, and a saved model to `docs/phase2_ml_siem/`. |

## Usage

Run from the same folder as your exported OpenSearch JSON file:

```
python isolation_forest_siem.py --input phase2_export.json
```

Outputs are written to `docs/phase2_ml_siem/`:

- `phase2_scored_windows.csv` - every feature window with its anomaly score, sorted by score descending.
- `isolation_forest_model.joblib` - the fitted model and feature scaler, saved for reuse.
- `phase2_report.txt` - text copy of the console summary.
- `fig_anomaly_scores.png` - histogram of anomaly scores split by benign vs attacker windows.
- `fig_detection_comparison.png` - bar chart of Phase 1 (rule-based) vs Phase 2 (ML) detection rate.

## Design Notes

The script is documented in detail inline. The ten behavioural features
it derives, the choice of contamination parameter, and the limitation
that the model needs a representative population of benign windows to
operate are all discussed both in the source comments and in
`docs/phase2_ml_siem/methodology_note_round1.md`.

## AI Assistance Declaration

This script was developed with the assistance of Claude (Anthropic).
All design decisions, parameter choices, methodology framing, and
final review were carried out by the author. The script was walked
through line by line so that its operation is understood and
defensible. See the project's main `README.md` for the full
declaration.
