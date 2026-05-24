# **LocalStack Setup Documentation (Updated for Standalone OpenSearch)**

## **1. Introduction**
LocalStack is used in this project to emulate AWS cloud services locally, allowing the SIEM pipeline to run without incurring AWS charges. It provides a safe, isolated, and repeatable environment for cybersecurity experimentation, including log ingestion, Lambda processing, and S3 storage.

**Important:**  
OpenSearch and OpenSearch Dashboards are **not** provided by LocalStack in this setup.  
They run as **separate standalone Docker containers**, which is why the dashboard is accessed on port **5601**, not through the LocalStack edge port.

---

## **2. Why LocalStack Was Used**
The original design used real AWS services, but early testing showed that SIEM‑related services generated high and unpredictable costs. Migrating to LocalStack allowed the project to:

- Maintain the cloud‑based architecture  
- Avoid all AWS charges  
- Run attack simulations safely  
- Keep the environment reproducible for assessment  

This change is documented in the proposal and supported by the archived original README.

---

## **3. System Requirements**
- Windows 10/11  
- Docker Desktop  
- PowerShell or Command Prompt  
- At least 8GB RAM  
- LocalStack auth token  

---

## **4. Installing LocalStack**

### **4.1 Pull the LocalStack image**
```powershell
docker pull localstack/localstack
```

### **4.2 Set the LocalStack authentication token**
```powershell
$env:LOCALSTACK_AUTH_TOKEN="your-token-here"
```

### **4.3 Verify the token**
```powershell
$env:LOCALSTACK_AUTH_TOKEN
```

---

## **5. Running LocalStack**

### **5.1 Start LocalStack**
```powershell
docker run --rm -it `
  -e LOCALSTACK_AUTH_TOKEN=$env:LOCALSTACK_AUTH_TOKEN `
  -p 4566:4566 `
  -p 4571:4571 `
  localstack/localstack
```

### **5.2 Expected behaviour**
LocalStack will start AWS‑compatible services such as:

- S3  
- CloudWatch Logs  
- Lambda  
- IAM  
- SNS/SQS (if enabled)  

**Note:**  
LocalStack does *not* run OpenSearch in this project.  
OpenSearch is handled separately.

---

## **6. Docker Compose Setup**
A `docker-compose.yml` file simplifies repeated testing.

```yaml
version: "3.8"
services:
  localstack:
    image: localstack/localstack
    container_name: localstack
    ports:
      - "4566:4566"
      - "4571:4571"
    environment:
      - SERVICES=s3,lambda,logs
      - DEBUG=1
      - LOCALSTACK_AUTH_TOKEN=${LOCALSTACK_AUTH_TOKEN}
    volumes:
      - "./localstack:/var/lib/localstack"
      - "/var/run/docker.sock:/var/run/docker.sock"
```

This file is stored in:

```
localstack/docker-compose.yml
```

---

## **7. Verifying LocalStack Services**

### **7.1 List S3 buckets**
```powershell
awslocal s3 ls
```

### **7.2 Check CloudWatch log groups**
```powershell
awslocal logs describe-log-groups
```

### **7.3 Verify Lambda functions**
```powershell
awslocal lambda list-functions
```

Screenshots of these commands are stored in:

```
docs/practical_evidence/localstack/
```

---

## **8. Integration With Standalone OpenSearch**
Because OpenSearch is **not** running inside LocalStack, the SIEM pipeline connects to:

- **LocalStack** for AWS services  
- **Standalone OpenSearch** for indexing and dashboards  

### **Correct endpoints:**

| Component | URL |
|----------|-----|
| LocalStack AWS services | `http://localhost:4566` |
| OpenSearch API | `http://localhost:9200` |
| OpenSearch Dashboards | `http://localhost:5601` |

This architecture is stable, modular, and avoids LocalStack’s OpenSearch limitations.

---

## **9. Evidence Collected**
The following screenshots are included:

- LocalStack running in PowerShell  
- Docker Desktop showing LocalStack container  
- S3 bucket creation  
- CloudWatch log groups  
- Lambda execution logs  
- SIEM pipeline sending logs to standalone OpenSearch  

Stored in:

```
docs/practical_evidence/localstack/
```

---

## **10. Conclusion**
LocalStack provides a reliable, cost‑free environment for emulating AWS services required by the SIEM system. Combined with standalone OpenSearch, this architecture preserves the original cloud‑based design while enabling safe attack simulations and reproducible testing.

This setup forms the foundation for the SIEM baseline and the later AI‑enhanced anomaly detection phase.



- **Update attack simulation documentation**  
- **Generate full Designs section**  
- **Create development diary**
