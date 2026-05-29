# Phase 2: ML-Enhanced SIEM

This folder documents the second phase of the project: adding a
machine-learning layer to the traditional SIEM and comparing both
detection approaches against the same dataset.

## What Was Built

Two independent ML detection components, both targeting the same
OpenSearch event index:

1. **OpenSearch Anomaly Detection plugin** (Random Cut Forest). The
   built-in, native ML capability that ships with OpenSearch 2.11.
   Configured through the OpenSearch Dashboards UI, runs inside the
   SIEM, and produces anomaly scores on a continuous time-series view
   alongside the other dashboard panels. This is the architecturally
   closest match to the project proposal's "ML within the SIEM
   framework" wording.

2. **Bespoke Python Isolation Forest script** (`../../ml/isolation_forest_siem.py`).
   A scikit-learn Isolation Forest model that reads an exported JSON
   from OpenSearch, builds per-source-IP-per-time-window behavioural
   features, scores every window, and reports detection performance
   against a ground-truth attacker IP. Used as a cross-check on the
   AD plugin result.

## Methodology Sequence

The project followed an iterative methodology with three full attack
runs across two phases:

1. **Phase 1 (original)**: traditional SIEM rules only, original
   dataset. Result: 4 of 7 attacks detected (57%).
2. **Phase 2 first iteration**: same lab data with bespoke Python ML
   added. Result: ML 0% recall, because the dataset was dominated by
   Fluent Bit log-shipper noise and had too few feature windows of
   genuine benign activity.
3. **Phase 2 (final)**: new attack run on top of a deliberately
   generated 60-minute benign baseline; ML run via both the AD plugin
   and the Python script. Result: traditional rules unchanged at 4 of
   7, both ML approaches still at 0% recall.

The first iteration's 0% result was investigated rather than
discarded. The investigation became the methodological finding: rule-
based and ML-based detection have substantively different data
requirements, and a SIEM tuned for one is not automatically tuned for
the other.

## Key Result

| Detection method | Recall on attacker windows |
|---|---|
| Traditional SIEM (rule-based dashboard, Phase 1 and Phase 2) | 4 of 7 (57%) consistent |
| Phase 2 OpenSearch Anomaly Detection plugin | 0 of 7 (0%) |
| Phase 2 Python Isolation Forest | 0 of 7 (0%) |

This headline is not "ML failed". It is "in this specific lab
configuration, the available benign data was insufficient for
unsupervised ML to operate, and a SIEM aiming to support ML detection
needs to be designed for richer baseline collection from the start."
This is a defensible real-world finding and is the project's principal
contribution.

## Artefacts

| Path | Contents |
|---|---|
| `methodology_note_round1.md` | Detailed analysis of the first ML run and the decision to iterate. |
| `logbook_2026-05-28.md` | Dated logbook entry capturing the iteration decision. |

## Future Work

To produce a positive ML detection result in this lab, three things
should be addressed:

1. Exclude Fluent Bit's own activity at source (it produced 94% of
   Phase 1 events) so the model's view of "normal" is not dominated
   by log-shipper noise.
2. Generate baseline activity from multiple source IPs across several
   hours, not just one host for 60 minutes.
3. Tune the Isolation Forest contamination hyperparameter against a
   held-out labelled validation set rather than using a literature
   default.

A supplementary experiment using the published CICIDS2017 dataset
would also confirm that the Isolation Forest algorithm itself is
operationally effective; the 0% lab result reflects dataset
limitations rather than algorithmic ones.
