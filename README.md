# AWS SIEM Baseline vs AI – Comparative Study

## Overview
This final-year Cyber Security major project investigates whether integrating machine learning techniques into a cloud-based Security Information and Event Management (SIEM) system improves intrusion detection performance compared to a traditional, rule-based SIEM.

The project is intentionally implemented in two distinct and sequential phases. First, a traditional AWS-based SIEM is designed, deployed, and tested to establish a performance baseline. The system is then enhanced with machine learning-based anomaly detection, tested again under the same conditions, and the results are compared to evaluate the impact of artificial intelligence on detection accuracy, false positives, and operational cost.

## Project Aim
To design, test, and evaluate a professional yet low-cost AWS-based SIEM, and to assess whether machine learning techniques can measurably improve intrusion detection compared to traditional rule-based approaches.

## Objectives
- Design and implement a low-cost, professional AWS-based SIEM using traditional rule-based detection.
- Test and evaluate the baseline SIEM using controlled attack simulations and quantitative security metrics.
- Identify limitations of traditional SIEM detection, particularly false positives and alert noise.
- Enhance the SIEM with machine learning-based anomaly detection techniques.
- Re-test the enhanced SIEM under the same conditions as the baseline system.
- Compare detection performance, false positives, and cost between the traditional and AI-enhanced SIEM implementations.

## Methodology
The project follows a design-science and experimental methodology:

1. Build a traditional AWS-based SIEM using native logging services and rule-based detection.
2. Simulate controlled attack scenarios in an isolated AWS lab environment.
3. Test the baseline SIEM and record detection performance, false positives, and cost.
4. Integrate machine learning models for anomaly detection into the SIEM pipeline.
5. Re-test the enhanced SIEM using the same attack scenarios and evaluation metrics.
6. Analyse and compare results to determine the effectiveness of machine learning enhancements.

This structured approach ensures a fair and controlled comparison between traditional and AI-enhanced SIEM approaches.

## Evaluation Strategy
Both the traditional and AI-enhanced SIEM implementations are evaluated using identical datasets, attack simulations, and metrics. Performance is assessed using precision, recall, false positive rate, alert volume, and cost efficiency to ensure experimental validity and repeatability.

## Repository Structure
- `docs/` – Project documentation, methodology, ethics, and architecture diagrams.
- `project-management/` – Risk register, decision log, and planning artefacts.
- `aws/` – AWS configuration notes, service setup, and deployment scripts.
- `simulation/` – Attack simulation and log generation scripts.
- `ml/` – Machine learning notebooks, training, and evaluation code.
- `evaluation/` – Results, metrics, and comparison outputs.

## Ethics and Scope
All data used in this project is synthetic or publicly available. No personal or sensitive data is processed. All attack simulations are performed in an isolated AWS environment for educational and research purposes only. The project complies with ethical and legal requirements relevant to cyber security research.

## Project Status
Project initialised.  
Current phase: **Baseline traditional SIEM design and setup**.
