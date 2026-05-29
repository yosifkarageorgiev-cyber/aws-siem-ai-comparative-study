# Phase 1: Traditional SIEM Results

This folder documents the first phase of the project: a working
traditional, rule-based SIEM built on OpenSearch, exercised against a
controlled set of seven attack scenarios from a Kali attacker VM.

## Detection Approach

Phase 1 detection is rule-based. The OpenSearch Dashboards interface
hosts a set of visualisations that act as the SIEM's rule layer:
counts of failed logons (EventID 4625), successful logons (4624),
account lockouts (4740), privilege assignments (4672), and a top
event-ID summary. An attack is considered "detected" if it produced
events that one of these dashboard tiles would have surfaced to an
analyst at a normal viewing threshold.

This is functionally equivalent to traditional SIEM rule evaluation
("if N failed logons in M seconds, alert") even though the dashboard
does not raise live alerts in the formal sense. It uses the same
underlying conditions on the same events.

## Attack Workload

The Kali attacker (192.168.56.103) executed seven attacks against the
Windows Server target (192.168.56.101) using `scripts/attack.sh`:

| # | Attack | Tool | Primary Windows event signal |
|---|---|---|---|
| 1 | Nmap reconnaissance | nmap | Network only, minimal auth signal |
| 2 | SMB brute force | Metasploit smb_login | Many 4625 failed logons |
| 3 | Authenticated SMB login | Metasploit smb_login (valid creds) | 4624 success + 4672 privilege |
| 4 | SMB user enumeration | Metasploit smb_enumusers | Anonymous logon attempts |
| 5 | MS17-010 vulnerability scan | Metasploit smb_ms17_010 | Minimal host auth signal |
| 6 | RDP brute force | Hydra | 4625 failed logons (LogonType 10) |
| 7 | WinRM brute force | Metasploit winrm_login | 4625 failed + possible 4740 lockout |

## Results

| Metric | Original Phase 1 run | Phase 2 re-run (same rules, fresh attacks) |
|---|---|---|
| Total events ingested | 8,636 | ~30,000 |
| Failed logons (4625) | 28 | 37 |
| Successful logons (4624) | 7 | 12 |
| Account lockouts (4740) | 1 | 0 |
| Privilege events (4672) | 6 | ~6 |
| **Attacks detected** | **4 of 7 (57%)** | **4 of 7 (57%)** |

The four detected attacks were the three brute-force types (Attacks 2,
6, 7) and the authenticated login (Attack 3). The three undetected
were the reconnaissance, enumeration, and vulnerability scan (Attacks
1, 4, 5).

The 57% rate is consistent across two independent attack runs,
confirming the rule-based detection is reliable and reproducible for
the attacks it can describe in rules.

## Why the Three Misses Matter

The undetected attacks share a property: they produce little or no
Windows authentication signal. Network reconnaissance happens below
the host's logging layer. SMB user enumeration uses null-session
queries that are recorded only as low-volume anonymous attempts. The
MS17-010 scan is a single-packet check that does not require
authentication. A rule based on counting authentication events has
nothing to fire on.

This is the gap the Phase 2 ML-enhanced SIEM is intended to address.
The Phase 2 results, methodology iteration, and findings are
documented in `../phase2_ml_siem/`.

## Artefacts

| Path | Contents |
|---|---|
| `attack_results/` | Timestamped result summaries produced by `scripts/collect_results.sh` after each attack run. |
