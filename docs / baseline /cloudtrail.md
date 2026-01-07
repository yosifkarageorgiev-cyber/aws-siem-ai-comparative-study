## CloudTrail – Baseline SIEM

CloudTrail was enabled to provide traditional SIEM-style audit logging.
This includes IAM actions, API calls, and management events across the AWS account.

Purpose:
- Establish baseline detection without AI
- Provide ground truth logs for later ML comparison

Trail name: siem-baseline-cloudtrail  
Region: eu-west-2 (London)

Status:
- CloudTrail trail successfully created
- Multi-region logging enabled
- Logs delivered to S3
- No real-time analysis or ML enabled (baseline phase)

CloudWatch Logs integration enabled for real-time monitoring.
Log group: /aws/cloudtrail/siem-baseline
