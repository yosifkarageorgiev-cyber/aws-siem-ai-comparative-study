# Lab Architecture

## Network
- Host: 192.168.56.1 (OpenSearch, LocalStack)
- Windows Server 2019: 192.168.56.101 (target)
- Kali Linux: attacker
- Metasploitable2: 192.168.56.105 (future target)

## Services
- OpenSearch 2.11.0 (port 9200)
- OpenSearch Dashboards (port 5601)
- LocalStack (port 4566)
- Fluent Bit 3.2.2 (log shipper)
