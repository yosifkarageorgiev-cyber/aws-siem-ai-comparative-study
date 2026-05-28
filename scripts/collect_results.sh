#!/bin/bash
echo "========================================="
echo "SIEM Results Collection Script"
echo "========================================="
OPENSEARCH="http://localhost:9200"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT="/c/Users/yosif/Desktop/siem-scripts/results_$TIMESTAMP.txt"

echo "Collecting results at $TIMESTAMP"
echo ""

echo "[1] Total events collected..."
TOTAL=$(curl -s "$OPENSEARCH/winlogbeat/_count" | grep -o '"count":[0-9]*' | grep -o '[0-9]*')
echo "Total events: $TOTAL"

echo ""
echo "[2] Failed logins (EventID 4625)..."
FAILED=$(curl -s -X GET "$OPENSEARCH/winlogbeat/_count" -H "Content-Type: application/json" -d '{"query":{"term":{"EventID":4625}}}' | grep -o '"count":[0-9]*' | grep -o '[0-9]*')
echo "Failed logins (4625): $FAILED"

echo ""
echo "[3] Successful logins (EventID 4624)..."
SUCCESS=$(curl -s -X GET "$OPENSEARCH/winlogbeat/_count" -H "Content-Type: application/json" -d '{"query":{"term":{"EventID":4624}}}' | grep -o '"count":[0-9]*' | grep -o '[0-9]*')
echo "Successful logins (4624): $SUCCESS"

echo ""
echo "[4] Account lockouts (EventID 4740)..."
LOCKOUT=$(curl -s -X GET "$OPENSEARCH/winlogbeat/_count" -H "Content-Type: application/json" -d '{"query":{"term":{"EventID":4740}}}' | grep -o '"count":[0-9]*' | grep -o '[0-9]*')
echo "Account lockouts (4740): $LOCKOUT"

echo ""
echo "[5] Privilege escalation (EventID 4672)..."
PRIV=$(curl -s -X GET "$OPENSEARCH/winlogbeat/_count" -H "Content-Type: application/json" -d '{"query":{"term":{"EventID":4672}}}' | grep -o '"count":[0-9]*' | grep -o '[0-9]*')
echo "Privilege events (4672): $PRIV"

echo ""
echo "========================================="
echo "RESULTS SUMMARY"
echo "========================================="
echo "Timestamp:              $TIMESTAMP"
echo "Total events:           $TOTAL"
echo "Failed logins (4625):   $FAILED"
echo "Successful logins (4624): $SUCCESS"
echo "Account lockouts (4740): $LOCKOUT"
echo "Privilege events (4672): $PRIV"
echo "========================================="

echo "Saving results to $OUTPUT..."
echo "Timestamp: $TIMESTAMP" > $OUTPUT
echo "Total events: $TOTAL" >> $OUTPUT
echo "Failed logins (4625): $FAILED" >> $OUTPUT
echo "Successful logins (4624): $SUCCESS" >> $OUTPUT
echo "Account lockouts (4740): $LOCKOUT" >> $OUTPUT
echo "Privilege events (4672): $PRIV" >> $OUTPUT
echo "Results saved."
