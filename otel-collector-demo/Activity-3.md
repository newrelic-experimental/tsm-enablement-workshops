# TASK 1
## Configure log receiver to obtain logs from our custom.log file located in /workspace/custom.log
https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/filelogreceiver

Add the filelog configuration to receivers block

Your configuration for receivers block should look like this

```
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318
  hostmetrics:
    collection_interval: 30s
    scrapers:
      cpu:
        metrics:
          system.cpu.time:
            enabled: true
          system.cpu.utilization:
            enabled: true
  filelog:
    include:
      - /workspace/custom.log
```

Add your filelog receiver in your logs pipeline in the service block
Your configuration for logs pipeline in service block should look like this

```
service:
  pipelines:
    logs:
      receivers: [filelog]
      processors: []
      exporters: [otlp/newrelic]
```

## Restart collector 
> ./collector.sh restart

## Send new log entries to our custom.log

> ./collector.sh generate_log_entry

# TASK 2
## Configure a processor that filters pii data in our custom.log file
https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor/transformprocessor

Your configuration for processors look like this

```
processors:
  transform/removepii:
    log_statements:
    - context: log
      statements:
          - merge_maps(attributes, ParseJSON(body), "upsert")
          - set(attributes["piidata"], "REDACTED")
          - set(body, "")
```

Add your transform processor in your logs pipeline in the service block
Your configuration forlogs pipeline in service block should look like this

```
service:
  pipelines:
    logs:
      receivers: [filelog]
      processors: [transform/removepii]
      exporters: [otlp/newrelic]
```

## Send new log entries to our custom.log

> ./collector.sh generate_log_entry

Your piidata should now be redated in New Relic
