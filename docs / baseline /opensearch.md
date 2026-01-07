## OpenSearch – Baseline SOC Dashboard

Amazon OpenSearch Service was deployed to act as the central SIEM dashboard for the baseline (non-AI) SOC architecture.

Purpose:
- Visualise CloudTrail security events
- Perform manual SOC analysis
- Establish a traditional SIEM baseline before AI/ML enhancement

Configuration summary:
- Domain name: siem-baseline-opensearch
- Region: eu-west-2 (London)
- Instance type: t3.small.search
- Availability: Single AZ
- Access: Public (IAM-authenticated)
- Fine-grained access control: Enabled
- Master user: IAM user (siem-admin)
- Encryption: HTTPS, node-to-node, at-rest enabled

Rationale:
This configuration reflects a realistic small-to-medium SOC deployment and avoids introducing AI or automated detection features at this stage. All detections and analysis are intended to be human-led.

Next steps:
- Connect CloudTrail logs
- Create SOC dashboards
- Simulate attack activity and analyse events using standard SOC workflows
