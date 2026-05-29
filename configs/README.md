# configs/ - Service Configurations

This folder contains the configuration files used by the SIEM's
collection pipeline. At present the project uses a single shipper
(Fluent Bit on the Windows Server) and a single destination
(OpenSearch on the Windows host).

## Files

| File | Used by | What it does |
|---|---|---|
| `fluent-bit.conf` | Fluent Bit service on the Windows Server VM | Defines the input (Windows Event Log channels), filtering, and the OpenSearch output endpoint. |

## fluent-bit.conf in Brief

The configuration is intentionally minimal so its behaviour is
auditable in one screen:

- `[SERVICE]` block: 5-second flush interval, log level info.
- `[INPUT]` block uses the `winlog` plugin and reads the Application,
  Security, and System channels every 1 second.
- `[OUTPUT]` block ships matched events to the OpenSearch instance on
  the Windows host (`192.168.56.1:9200`) into the `winlogbeat` index.
  `Suppress_Type_Name` is set to `On` because OpenSearch 2.x removed
  per-type mappings; without this flag the index would reject the
  documents.

## Deployment on the Server

Fluent Bit runs as a Windows service installed via NSSM (the
Non-Sucking Service Manager). The service is registered with the
fluent-bit executable as the application and this configuration file
as its only argument. The service is set to start automatically on
boot so logs continue shipping after a server restart.
