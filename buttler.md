# Butler Security Assessment Notes  
**Author:** Bharath R    
**Machine Source:** VulnHub “Butler” (public educational VM)  
**Date:** 18 Jul 2025

---

## Purpose
This repository documents the **step-by-step security assessment** I performed on the intentionally vulnerable Butler virtual machine.  
All activities were carried out **in an isolated lab** for learning and portfolio purposes only.

---

## Executive Summary
- **Target:** Windows 7 host running Jenkins 2.89.4  
- **Approach:** Manual reconnaissance, vulnerability identification, and safe exploitation  
- **Outcome:** Successfully obtained administrative (SYSTEM) access and produced remediation guidance  
- **Time Invested:** ~25 minutes from initial scan to final proof

---

## Attack Narrative (Plain English)

1. **Discovery**  
   A port scan revealed Jenkins on port 8080 and an SSH service on port 7744.

2. **Credential Testing**  
   Used standard username/password lists against Jenkins; identified weak credentials that allowed login.

3. **Exploitation**  
   Leveraged Jenkins’ built-in script console to run a safe command that opened a reverse shell for analysis.

4. **Privilege Escalation**  
   After gaining a low-privilege shell, I identified the Windows “SeBackupPrivilege” setting and used it—via legitimate utilities—to obtain SYSTEM rights.

5. **Proof of Control**  
   Captured screenshots and the final flag provided by the VM author to confirm full compromise.

---

## Remediation Highlights
- Enforce strong passwords on Jenkins accounts.  
- Disable or restrict the Jenkins script console in production.  
- Review Windows privilege assignments to prevent misuse of backup rights.  
- Keep Jenkins updated to the latest LTS version.

---


## Contact
For questions or to view additional projects:  
GitHub: [github.com/bharath-cyber-root](https://github.com/bharath-cyber-root)  
E-mail: bharathr1407@gmail.com
