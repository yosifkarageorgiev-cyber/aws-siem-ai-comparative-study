- **Standalone OpenSearch + OpenSearch Dashboards running in Docker**
- **Port 5601 for the dashboard UI**
- **Port 9200 for the OpenSearch API**
- **NOT using LocalStack for OpenSearch**

This version is clean, dissertation‑ready, and matches your actual architecture.

You can paste this directly into:

```
docs/practical_evidence/opensearch_dashboard.md
```

---

# **OpenSearch Dashboard Documentation (Standalone Docker Version)**

## **1. Introduction**
OpenSearch Dashboards provides the visualisation and analysis layer for the SIEM system. In this project, OpenSearch and OpenSearch Dashboards run as **standalone Docker containers**, separate from LocalStack. This setup provides full control over indexing, querying, and dashboard creation while maintaining compatibility with the SIEM pipeline.

OpenSearch Dashboards is used to:

- Inspect ingested logs  
- Create index patterns  
- Build visualisations  
- Construct the baseline SIEM dashboard  
- Validate detection of attack simulations  

---

## **2. Accessing OpenSearch Dashboards**
Since OpenSearch Dashboards is running as a standalone Docker container, it uses the default port:

```
http://localhost:5601
```

This is the correct URL for your setup.

### **2.1 OpenSearch API Endpoint**
The OpenSearch backend is available at:

```
http://localhost:9200
```

This endpoint is used for:

- Index verification  
- Query testing  
- Debugging ingestion issues  

---

## **3. Docker Setup**

### **3.1 Example docker‑compose.yml**
Your setup typically includes:

```yaml
version: '3.8'
services:
  opensearch:
    image: opensearchproject/opensearch:latest
    container_name: opensearch
    environment:
      - discovery.type=single-node
      - plugins.security.disabled=true
    ports:
      - "9200:9200"

  dashboards:
    image: opensearchproject/opensearch-dashboards:latest
    container_name: opensearch-dashboards
    ports:
      - "5601:5601"
    environment:
      - OPENSEARCH_HOSTS=http://opensearch:9200
```

This configuration ensures:

- OpenSearch runs on port **9200**  
- Dashboards runs on port **5601**  
- Security plugin is disabled for local testing  
- Dashboards connects directly to the OpenSearch container  

---

## **4. Creating a Data View (Index Pattern)**

### **4.1 Navigate to Data Views**
Inside OpenSearch Dashboards:

1. Open the left menu  
2. Select **Stack Management**  
3. Select **Data Views**  

### **4.2 Create a new Data View**
Use the following settings:

- **Name:** `logs`  
- **Index pattern:**  
  ```
  logs-*
  ```
  or  
  ```
  *
  ```
- **Timestamp field:**  
  ```
  @timestamp
  ```

### **4.3 Save the Data View**
Once saved, the dashboard interface unlocks:

- Add panel  
- Add visualisation  
- Add saved search  
- Add Lens panel  

This confirms that OpenSearch is receiving and indexing logs correctly.

---

## **5. Verifying Log Ingestion**

### **5.1 Check indices**
Use the Dev Tools console:

```json
GET _cat/indices?v
```

Expected output includes something like:

```
yellow open logs-2026.05.22
```

### **5.2 Query logs**
Retrieve the latest 20 log entries:

```json
GET logs-*/_search?size=20
```

This verifies:

- Timestamps  
- Event IDs  
- Source IPs  
- Attack logs (SSH brute force, Nmap scans, etc.)  

Screenshots of these results are stored in:

`docs/practical_evidence/opensearch/`

---

## **6. Building the SIEM Dashboard**

### **6.1 Create a new dashboard**
Navigate to:

**OpenSearch Dashboards → Dashboard → Create new**

### **6.2 Add panels**
Panels created for this project include:

- **Event Count Over Time**  
- **Top Source IPs**  
- **Top Event IDs**  
- **SSH Authentication Failures**  
- **Nmap Scan Detection**  
- **Anomaly Detection (ML Phase)**  

Each panel uses the `logs-*` index pattern.

### **6.3 Save the dashboard**
Name it:

```
SIEM Baseline Dashboard
```

This dashboard forms the baseline for comparison with the AI‑enhanced SIEM.

---

## **7. Evidence Collected**
The following screenshots have been captured:

- OpenSearch Dashboard home  
- Data View creation  
- Dev Tools index verification  
- Log search results  
- Dashboard with multiple panels  
- Individual visualisations  

These are stored in:

`docs/practical_evidence/opensearch/`

---

## **8. Conclusion**
OpenSearch Dashboards, running as a standalone Docker container, provides a powerful and flexible visualisation layer for the SIEM system. It enables verification of log ingestion, supports dashboard creation, and forms the baseline for comparing traditional SIEM performance with the AI‑enhanced anomaly detection phase.

This configuration accurately reflects the real environment used in the project and supports reproducible, cost‑free experimentation.
