# **LocalStack Setup Documentation**

## **1. Introduction**
LocalStack is a fully local AWS cloud emulator that replicates core AWS services such as S3, CloudWatch Logs, Lambda, and OpenSearch. It allows the SIEM system to be deployed, tested, and evaluated without incurring AWS charges. This setup provides a controlled, repeatable, and isolated environment suitable for cybersecurity experimentation and attack simulation.

---

## **2. Why LocalStack Was Used**
The original project design used live AWS services. However, early testing showed that SIEM‑related services generated high and unpredictable costs. To maintain feasibility and methodological integrity, the implementation was migrated to LocalStack. This preserved the cloud‑based architecture while eliminating financial risk and ensuring safe, isolated experimentation.

A full explanation of this decision is included in the **Methodology chapter** and supported by the archived original README in the GitHub history.

---

## **3. System Requirements**
- Windows 10/11  
- Docker Desktop installed and running  
- PowerShell or Command Prompt  
- At least 8GB RAM  
- Internet connection (for pulling images)

---

## **4. Installing LocalStack**

### **4.1 Pull the LocalStack Docker image**
```powershell
docker pull localstack/localstack
```

### **4.2 Set the LocalStack authentication token (PowerShell)**
```powershell
$env:LOCALSTACK_AUTH_TOKEN="your-token-here"
```

### **4.3 Verify the token is set**
```powershell
$env:LOCALSTACK_AUTH_TOKEN
```

---

## **5. Running LocalStack (PowerShell)**

### **5.1 Start LocalStack**
```powershell
docker run --rm -it `
  -e LOCALSTACK_AUTH_TOKEN=$env:LOCALSTACK_AUTH_TOKEN `
  -p 4566:4566 `
  -p 4571:4571 `
  localstack/localstack
```

### **5.2 Expected output**
You should see LocalStack boot logs showing services starting, including:

- S3  
- CloudWatch Logs  
- Lambda  
- OpenSearch  

A screenshot of this output is included in the practical evidence folder.

---

## **6. Docker Compose Configuration**
A `docker-compose.yml` file was created to simplify repeated testing.

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
      - SERVICES=s3,lambda,logs,opensearch
      - DEBUG=1
      - LOCALSTACK_AUTH_TOKEN=${LOCALSTACK_AUTH_TOKEN}
    volumes:
      - "./localstack:/var/lib/localstack"
      - "/var/run/docker.sock:/var/run/docker.sock"
```

This file is stored in:

`localstack/docker-compose.yml`

---

## **7. Verifying LocalStack Services**

### **7.1 List running services**
```powershell
awslocal s3 ls
awslocal logs describe-log-groups
awslocal opensearch list-domain-names
```

### **7.2 Expected results**
- S3 bucket list (empty at first)  
- CloudWatch log groups (empty at first)  
- OpenSearch domain visible  

Screenshots of these commands are included in the evidence folder.

---

## **8. OpenSearch Dashboard Access**
LocalStack exposes OpenSearch at:

```
http://localhost:4566/opensearch
```

The dashboard was used to:

- Create index patterns  
- View ingested logs  
- Run queries  
- Validate SIEM behaviour  

Screenshots of the dashboard are included in:

`docs/practical_evidence/opensearch/`

---

## **9. Integration with the SIEM Pipeline**
LocalStack services were integrated into the SIEM pipeline as follows:

- **S3** — log storage  
- **CloudWatch Logs** — log ingestion  
- **Lambda** — log parsing and forwarding  
- **OpenSearch** — indexing and visualisation  

This mirrors the original AWS architecture while remaining cost‑free and fully local.

---

## **10. Evidence Collected**
The following evidence has been captured and stored in the repository:

- LocalStack running in PowerShell  
- Docker Desktop container view  
- OpenSearch dashboard  
- Log ingestion tests  
- Lambda execution logs  
- S3 bucket creation  
- CloudWatch log groups  

These screenshots are stored in:

`docs/practical_evidence/localstack/`

---

## **11. Conclusion**
LocalStack provides a reliable, cost‑free, and safe environment for implementing and testing the SIEM system. It preserves the cloud‑based architecture originally designed for AWS while enabling controlled attack simulations and repeatable experiments essential for the comparative study.


- **Development diary**  

Tell me which one you want next.
