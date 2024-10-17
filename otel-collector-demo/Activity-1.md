# TASK 1
## Configure hostmetrics receiver to obtain cpu utilization and exclude cpu time.
https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/README.md

Add the hostmetrics configuration to receivers block
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
    # Default collection interval is 60s. Lower if you need finer granularity.
    collection_interval: 60s
    scrapers:
      cpu:
        metrics:
          system.cpu.time:
            enabled: false
          system.cpu.utilization:
            enabled: true
```

Add your hostmetrics receiver in your metrics pipeline in the service block

Your configuration for metrics pipeline in service block should look like this

```
service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp]
    metrics:
      receivers: [otlp,hostmetrics]
      processors: [batch]
      exporters: 
       - otlp
    logs:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp]
```

## Restart collector 
> ./collector.sh restart

# TASK 2
## Exclude system.cpu metrics for cpu states interrupt, nice, softirq
https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/processor/filterprocessor/README.md

Configure filter processor in processor block

Your filter configuration in processors block should look like this

```
processors:
  # remove system.cpu metrics for states
  filter/exclude_cpu_utilization:
    metrics:
      datapoint:
        - 'metric.name == "system.cpu.utilization" and attributes["state"] == "interrupt"'
        - 'metric.name == "system.cpu.utilization" and attributes["state"] == "nice"'
        - 'metric.name == "system.cpu.utilization" and attributes["state"] == "softirq"'
```

Add your filter processor in your metrics pipeline in the service block
Your configuration for metrics pipeline in service block should look like this

```
service:
  pipelines:
    metrics:
      receivers: [otlp,hostmetrics]
      processors: [filter/exclude_cpu_utilization, batch]
      exporters: [otlp]
```

## Restart collector 
> ./collector.sh restart