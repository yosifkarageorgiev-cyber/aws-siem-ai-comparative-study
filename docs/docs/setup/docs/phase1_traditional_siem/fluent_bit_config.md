# Fluent Bit Configuration - Phase 1

## Version
Fluent Bit 3.2.2 on Windows Server 2019

## Config
```ini
[SERVICE]
    Flush        5
    Daemon       Off
    Log_Level    info

[INPUT]
    Name         winlog
    Channels     Application,Security,System
    Interval_Sec 1

[OUTPUT]
    Name            opensearch
    Match           *
    Host            192.168.56.1
    Port            9200
    Index           winlogbeat
    Suppress_Type_Name On
    tls             Off
```

## Notes
- Installed as Windows service via NSSM
- Collects Security, System, Application event logs
- Ships to OpenSearch at 192.168.56.1:9200
