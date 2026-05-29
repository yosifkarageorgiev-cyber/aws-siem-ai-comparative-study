# scripts/ - Lab Automation

Shell and PowerShell scripts that automate the lab's setup, attack
workload, baseline generation, and result collection. Each script is
self-contained and documented inline with usage notes.

## Files

| File | Where it runs | What it does |
|---|---|---|
| `reset.sh` | Windows host (Git Bash) | Wipes the `winlogbeat` index in OpenSearch back to zero events. Used between experiment runs to ensure a clean dataset. |
| `attack.sh` | Kali Linux attacker VM | Runs the seven controlled attack scenarios in sequence against the Windows Server target. Uses nmap, Metasploit (smb_login, smb_enumusers, smb_ms17_010, winrm_login) and Hydra (rdp). |
| `collect_results.sh` | Windows host (Git Bash) | Produces a timestamped text summary of the current OpenSearch index: total events, failed logons (4625), successful logons (4624), account lockouts (4740), and privilege events (4672). |
| `baseline_activity.ps1` | Windows host (PowerShell, normal user) | Original baseline activity generator. Runs for 90 minutes producing realistic admin activity (SMB browsing, WMI queries, file access) against the target. Note: known to freeze on slower hosts due to network operations that can hang. Kept for reference. |
| `baseline_activity_v2.ps1` | Windows host (PowerShell, normal user) | Freeze-resistant rewrite of the baseline generator. Each operation has a strict per-call timeout (10 seconds) using PowerShell background jobs, so no operation can hang the whole script. Used for the final Phase 2 attack run. |

## Typical Run Sequence

For a full reproducible experiment:

1. `bash reset.sh` on the Windows host - clean OpenSearch
2. `.\baseline_activity_v2.ps1` on the Windows host - 60 minutes of benign activity
3. `sudo ./attack.sh` on Kali - seven attacks on top of the baseline
4. `bash collect_results.sh` on the Windows host - dataset summary
5. `python ../ml/isolation_forest_siem.py --input <export>.json` - ML scoring

## AI Assistance Declaration

The `baseline_activity.ps1` and `baseline_activity_v2.ps1` scripts were
developed with the assistance of Claude (Anthropic). All design
decisions and final review were carried out by the author. See the
project's main `README.md` for the full declaration.
