# AWS SIEM Baseline vs AI - Comparative Study

A final-year Cyber Security major project at Leeds City College.
This project compares two ways of detecting attacks against a Windows
server: a traditional rule-based Security Information and Event
Management (SIEM) system, and the same SIEM enhanced with machine
learning anomaly detection.

## What This Project Does

Traditional SIEMs rely on rules written by humans: "if there are 20
failed logons in 10 seconds, raise an alert." These rules work well for
attacks that match known patterns but miss attacks the rule designer
never thought of, typically reconnaissance and low-volume probing.

Machine learning detection works differently. Instead of rules, an
algorithm learns what "normal" activity looks like from observed data
and flags anything that does not fit. This can catch the quieter
attacks that rules miss, but only if it has been given enough normal
activity to learn from.

This project builds both detection methods in the same lab, runs the
same seven attacks against both, and compares what each catches.

## Headline Results

| Detection method | Attacks detected | Rate |
|---|---|---|
| Phase 1 traditional SIEM (rule-based dashboard queries) | 4 of 7 | 57% |
| Phase 2 traditional SIEM (same rules, fresh attack run) | 4 of 7 | 57% |
| Phase 2 OpenSearch Anomaly Detection plugin (Random Cut Forest) | 0 of 7 | 0% |
| Phase 2 Python Isolation Forest (bespoke script) | 0 of 7 | 0% |

The traditional SIEM produced a consistent 57% detection rate across
two independent attack runs, missing the three low-signal attacks
(nmap reconnaissance, SMB user enumeration, MS17-010 vulnerability
scan). Both ML approaches produced 0% recall in this lab environment.
This is not an algorithmic failure but a dataset finding, discussed in
detail in `docs/phase2_ml_siem/methodology_note_round1.md` and in the
Phase 2 portfolio supplement. The lab's event stream was dominated by
Fluent Bit's own log-shipper noise (Event ID 4703 accounted for 94% of
all events), leaving too few feature windows of representative benign
activity for any unsupervised anomaly detector to learn from.

The headline finding of the project is therefore not "ML beats rules"
but "ML and rules have different data requirements, and a SIEM that
serves rule-based detection well may not serve ML-based detection
without changes to the collection pipeline." This is a defensible,
real-world result.

## What's in This Repository

| Folder | Contents |
|---|---|
| `configs/` | Fluent Bit configuration used to ship Windows events to OpenSearch. |
| `docs/setup/` | Lab architecture, OpenSearch and LocalStack setup notes. |
| `docs/phase1_traditional_siem/` | Phase 1 results from the traditional rule-based SIEM. |
| `docs/phase2_ml_siem/` | Phase 2 ML-enhanced SIEM design, methodology notes, and results. |
| `ml/` | Python ML detection script (Isolation Forest). |
| `scripts/` | reset.sh, attack.sh, collect_results.sh, baseline_activity.ps1: the lab automation. |

## Lab Setup

Everything runs on a single Windows 11 laptop using VirtualBox and
Docker Desktop. There is no real cloud spend and no public network
exposure. The whole lab sits on a private host-only VirtualBox network
(192.168.56.0/24).

| Component | Address / Port | Role |
|---|---|---|
| Windows 11 host | 192.168.56.1 | Runs Docker; hosts OpenSearch, OpenSearch Dashboards, LocalStack. |
| OpenSearch 2.11.0 | localhost:9200 | The SIEM backend. Stores all events. |
| OpenSearch Dashboards | localhost:5601 | The SOC-style visual dashboard and Anomaly Detection plugin UI. |
| LocalStack | localhost:4566 | Simulates AWS S3 and IAM locally. |
| Windows Server 2019 (VM) | 192.168.56.101 | The target. Runs Fluent Bit (as a service via NSSM) which ships Windows events to OpenSearch. |
| Kali Linux (VM) | 192.168.56.103 | The attacker. Runs nmap, Metasploit, Hydra. |

## The Two Phases

### Phase 1: Traditional SIEM (rule-based)

Detection works by querying OpenSearch with rules: count failed logons,
look for lockouts, look for privileged use. Phase 1 is the baseline the
ML approach is measured against.

Phase 1 result on the original dataset: 4 of 7 attacks detected (57%).
The three missed attacks (nmap recon, SMB enumeration, MS17-010 scan)
produce little or no Windows authentication signal, so rule-based
detection has nothing to fire on.

### Phase 2: ML-Enhanced SIEM

Two ML approaches are implemented:

1. Built-in OpenSearch Anomaly Detection plugin. Uses Random Cut
   Forest, which is the streaming variant of Isolation Forest.
   Configured through the OpenSearch Dashboards UI; runs inside
   OpenSearch itself; alerts appear on the dashboard alongside
   rule-based ones. This is the architecturally cleanest "ML-enhanced
   SIEM" since the ML runs inside the SIEM, not next to it.

2. Bespoke Python Isolation Forest script (`ml/isolation_forest_siem.py`).
   Implements the same algorithmic family externally. Used both as a
   methodological cross-check and because it was what the original
   project proposal specified.

## How the Comparison Works (Plain-English Version)

To make the comparison approach easy to follow, here is a simple analogy
before the formal version.

Imagine three people watching the same football match on television.
The first counts goals. The second watches for fouls. The third watches
for skilful passes. At the end, each gives their own report. They
watched the same match. The match did not change because three people
were watching it, so the three reports can be compared fairly. Each
observer simply looked for different things and wrote down what they
saw on their own scorecard.

The Phase 2 experiment uses the same idea. The "match" is the stream of
Windows events flowing through OpenSearch (the baseline activity plus
the seven attacks). The three observers are:

- The traditional SIEM with its rule-based dashboard queries
- The OpenSearch Anomaly Detection plugin running Random Cut Forest
  inside the SIEM itself
- The bespoke Python Isolation Forest script run after collection

The detection methods operate independently. None of them modifies the
underlying events. What they do change is the dashboard, because each
detector adds its own findings to the SOC analyst's screen. A SOC
analyst still investigates by looking at the dashboard, but the
dashboard gains new sections as more detectors are running. The
comparison measures which detection method gives the analyst the most
useful alerts to act on, drawn from the same underlying data.

## Why a Fair Comparison Requires a Baseline

Rule-based detection needs only the attack signal. Machine-learning
detection needs both the attack signal and a representative population
of normal activity to learn from. This is a property of how
unsupervised learning works, not a flaw in any specific algorithm.

In Phase 2 (first iteration) of the experiment, the dataset contained mostly Fluent Bit's
own internal events and almost no diversity of benign activity. The ML
model could not learn a meaningful boundary and produced 0% recall.
This was documented and used as a methodological iteration point.

In Phase 2, a baseline-activity script (`scripts/baseline_activity.ps1`)
ran on the Windows host for 60 minutes before the attacks, simulating a
normal administrator's daily work (SMB browsing, port probes,
authenticated share access, name lookups). This produces real Windows
authentication events from a distinct source IP (192.168.56.1, the
host), giving the ML model an authentic baseline to learn from. The
same attack workload was then run from Kali (192.168.56.103) on top.
Both detection methods were evaluated against the same combined dataset.

The fairness of the comparison lies in this: the data is identical for
both methods. Only the detection algorithm changes.

## Methodology Iterations (Honest Account)

The project followed an iterative methodology with three full attack
runs:

| Iteration | What was tested | Outcome |
|---|---|---|
| Phase 1 (original) | Traditional SIEM rules only | 4 of 7 attacks detected (57%) |
| Phase 2 (first iteration) | Same lab data, plus bolt-on Python ML | ML 0% recall: dataset too sparse to learn from |
| Phase 2 | New attack run on top of generated benign baseline; ML run as both AD plugin and Python script | Traditional 4 of 7 again (consistent). Both ML approaches 0% recall: even with a 60-minute baseline, Fluent Bit log-shipper noise dominated, leaving too few feature windows for the algorithm to operate |

The repository documents each iteration honestly:

- `docs/phase2_ml_siem/methodology_note_round1.md` documents what was
  learned from the first ML run and why iteration was needed.
- `docs/phase2_ml_siem/logbook_2026-05-28.md` is a dated logbook entry
  recording the iteration decision.

These iterations are deliberate inclusions. In a research project, an
honest account of what was tried and what did not work is itself
evidence of methodological maturity (LO9 of the module brief: act
autonomously with limited supervision or guidance within agreed
guidelines), and points to genuine future work rather than a polished
but possibly fabricated result.

## How to Reproduce

1. Bring up the lab (`docker-compose up -d` in the project root, plus
   the two VMs).
2. Reset OpenSearch: `bash scripts/reset.sh`
3. Run the baseline generator on the Windows host:
   `powershell -File scripts/baseline_activity.ps1`
4. Configure the Anomaly Detection plugin in OpenSearch Dashboards
   pointed at the `winlogbeat` index (see
   `docs/phase2_ml_siem/anomaly_detector_setup.md`).
5. Run the attacks from Kali: `sudo ./scripts/attack.sh`.
6. Read the traditional-SIEM detection result from the OpenSearch
   dashboard.
7. Export events: see `scripts/collect_results.sh` and the curl command
   in the Phase 2 docs.
8. Run the bespoke ML model:
   `python ml/isolation_forest_siem.py --input phase2_export.json`
9. Compare results.

## Honest Limitations

Three limitations of this study should be acknowledged in any reading
of the results:

1. The dataset was dominated by Fluent Bit's own log-shipper events.
   This left too few feature windows of representative benign activity
   for unsupervised ML to operate effectively. A production deployment
   would either configure Fluent Bit to exclude its own activity at
   source, or run a substantially longer baseline collection across
   multiple host sources.

2. Ground truth on the attacker side was established at the granularity
   of source IP and time window, not at the granularity of individual
   attack actions. This is a methodological simplification driven by
   the unlabelled nature of the dataset.

3. The contamination hyperparameter of the Isolation Forest was set to
   a literature default rather than tuned against held-out labelled
   data. A more rigorous evaluation would sweep this parameter and
   report the precision-recall curve.

Future work would address all three: a richer multi-source baseline
collection over several hours, per-attack labelling of events, and
hyperparameter sweeping.

## Ethics

All testing is performed on an isolated host-only network using only
machines owned by the author. No external systems or networks are
targeted. The lab complies with the Computer Misuse Act 1990 (all
access is self-authorised) and follows the BCS Code of Conduct.

## AI Assistance Declaration

Parts of the Python ML detection script and the PowerShell baseline
generator were developed with the assistance of Claude (Anthropic).
All design decisions, parameter choices, methodology framing, testing,
and final review were carried out by the author. Code was walked
through line by line so that every part is understood and defensible.
This use is declared transparently in the portfolio.

## Module Information

| Detail | Value |
|---|---|
| Module | Major Project (Level 6, 40 credits) |
| Programme | BSc (Hons) Cyber Security |
| Institution | Leeds City College, University Centre |
| Academic Year | 2025-2026 |
| Supervisor | Glynn Bolton |
| Author | Yosif Karageorgiev |
