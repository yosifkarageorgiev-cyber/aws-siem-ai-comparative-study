docs/practical_evidence/opensearch_dashboard.md
```

It follows dissertation‑grade structure, includes everything assessors expect, and links naturally into your LocalStack setup.

Guided Links are included so you can expand sections later.

---

# **OpenSearch Dashboard Documentation**

## **1. Introduction**
OpenSearch Dashboards provides the visualisation layer for the SIEM system implemented in LocalStack. It enables the creation of index patterns, dashboards, visualisations, and queries used to analyse ingested security logs. This documentation outlines how OpenSearch Dashboards was configured, accessed, and used to validate the SIEM pipeline.

---

## **2. Accessing OpenSearch Dashboards**
After LocalStack is running, OpenSearch Dashboards becomes available at:

```
http://localhost:4566/opensearch
```

This interface is used to:

- Create data views (index patterns)  
- Inspect ingested logs  
- Build dashboards  
- Run queries  
- Validate SIEM behaviour  

Screenshots of the dashboard interface are stored in:

`docs/practical_evidence/opensearch/`

---

## **3. Creating a Data View (Index Pattern)**

### **3.1 Navigate to Data Views**
Inside OpenSearch Dashboards:

1. Open the left‑hand menu  
2. Select **Stack Management**  
3. Select **Data Views**

### **3.2 Create a new Data View**
Click **Create data view** and enter:

- **Name:** `logs`  
- **Index pattern:**  
  ```
  logs-* 
  ```
  or  
  ```
  *
  ```
  depending on your ingestion naming scheme  
- **Timestamp field:**  
  ```
  @timestamp
  ```

### **3.3 Save the Data View**
Once saved, the dashboard interface unlocks:

- Add panel  
- Add visualisation  
- Add saved search  
- Add Lens panel  

This confirms that OpenSearch is receiving and indexing logs correctly.

---

## **4. Verifying Log Ingestion**

### **4.1 Using Dev Tools**
Open:

**Dev Tools → Console**

Run:

```json
GET _cat/indices?v
```

Expected output includes something like:

```
yellow open logs-2026.05.22
```

This confirms:

- The index exists  
- LocalStack → OpenSearch ingestion is working  
- The SIEM pipeline is active  

### **4.2 Searching the logs**
Run:

```json
GET logs-*/_search?size=20
```

This retrieves the latest 20 log entries and verifies:

- Timestamp fields  
- Event IDs  
- Source IPs  
- Attack logs (e.g., SSH brute force, Nmap scans)  

Screenshots of these results are included in the evidence folder.

---

## **5. Building the Dashboard**

### **5.1 Create a new dashboard**
Navigate to:

**OpenSearch Dashboards → Dashboard → Create new**

### **5.2 Add panels**
Panels created for this project include:

- **Event Count Over Time**  
- **Top Source IPs**  
- **Top Event IDs**  
- **SSH Authentication Failures**  
- **Nmap Scan Detection**  
- **Anomaly Detection (ML Phase)**  

Each panel uses the `logs-*` index pattern and visualises different aspects of the ingested data.

### **5.3 Save the dashboard**
Name it:

```
SIEM Baseline Dashboard
```

This dashboard is used as the baseline for comparison with the AI‑enhanced SIEM.

---

## **6. Example Visualisations**

### **6.1 Event Count Over Time**
- Type: Line chart  
- X‑axis: `@timestamp`  
- Y‑axis: Count  
- Purpose: Shows spikes during attack simulations  

### **6.2 Top Source IPs**
- Type: Bar chart  
- Field: `source.ip`  
- Purpose: Identifies attacker IPs during brute‑force attempts  

### **6.3 SSH Authentication Failures**
- Type: Metric or Table  
- Field: `event.id` or `message`  
- Purpose: Detects brute‑force behaviour  

### **6.4 Nmap Scan Detection**
- Type: Table  
- Field: `event.type` or `network.transport`  
- Purpose: Shows port scan activity  

All visualisations are stored in:

`docs/practical_evidence/opensearch/visualisations/`

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
OpenSearch Dashboards provides the analytical and visualisation layer for the SIEM system. It enables verification of log ingestion, supports dashboard creation, and provides the baseline for comparing traditional SIEM performance with the AI‑enhanced anomaly detection phase. The configuration and evidence collected demonstrate a functioning SIEM pipeline within LocalStack.


