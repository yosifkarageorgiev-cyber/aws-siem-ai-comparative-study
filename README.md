# AWS SIEM Baseline vs AI - Comparative Study

## Overview

This final-year Cyber Security major project investigates whether integrating machine learning techniques into a cloud-based Security Information and Event Management (SIEM) system improves intrusion detection performance compared to a traditional, rule-based SIEM.

## Implementation

The project is implemented in two distinct and sequential phases:

1. A traditional SIEM is designed, deployed, and tested to establish a performance baseline
2. The system is then enhanced with machine learning-based anomaly detection, tested again under the same conditions, and the results are compared

## Lab Environment

- **Host:** Windows 11 laptop running Docker Desktop
- **SIEM Backend:** OpenSearch 2.11.0 (Docker)
- **Dashboard:** OpenSearch Dashboards (Docker)
- **Cloud Simulation:** LocalStack (Docker) - simulates AWS S3, IAM
- **Log Shipper:** Fluent Bit 3.2.2
- **Attacker VM:** Kali Linux (VirtualBox)
- **Target VM:** Windows Server 2019 (VirtualBox) - 192.168.56.101

## Repository Structure

- `configs/` - Fluent Bit and service configuration files
- `docs/setup/` - Lab architecture and setup documentation
- `docs/phase1_traditional_siem/` - Phase 1 results and attack evidence
- `docs/phase2_ml_siem/` - Phase 2 ML model and results
- `ml/` - Machine learning models and training code

## Methodology

1. Build traditional SIEM with rule-based detection
2. Run controlled attacks from Kali Linux against Windows Server 2019
3. Record detection metrics (precision, recall, false positives)
4. Add ML anomaly detection layer
5. Repeat same attacks
6. Compare and analyse results

## Evaluation Metrics

- Detection rate
- False positive rate
- False negative rate
- Time to detection
- Alert volume

## Ethics

All attack simulations are performed in an isolated local lab environment for educational and research purposes only. No real systems or networks are targeted.

## Project Status

Current phase: **Phase 1 - Traditional SIEM baseline in progress**
