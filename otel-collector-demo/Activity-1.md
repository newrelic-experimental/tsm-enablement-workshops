# Exercise 1

## Task 1: Add a receiver to collect host CPU metrics 

Receviers allow the collector to receive data. There are numerous receivers available for many different technologies. For this example we want to gather CPU metrics. The "hostmetrics" receiver can provide this data. Read more about the [hostmetrics receiver here](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/README.md).

To add the hostmetrics recever to your collector do the follow:

1. Review the documentation for [hostmetrics](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/README.md)
2. Add a `hostmetric` block to the `receivers` section of [customconfig.yml](customconfig.yml)
3. Set the colleciton_interval to 60 seconds and add a `system.cpu.time` scraper as below:

```
receivers:
  hostmetrics:
    collection_interval: 60s
    scrapers:
      cpu:
        metrics:
          system.cpu.time:
            enabled: false
```

The receiver is configured, but we need to configure where the receved data is sent. The hostmetrics receiver generates metrics, so we need to configure the `metrics` pipeline to receive metrics from `hostmetrics`.

4. Add the `hostmetrics` receiver to the list of receivers in the `metrics` pipeline

```
    metrics:
      receivers: [otlp,hostmetrics]
      processors: [batch]
      exporters: 
       - otlp
```

5. Restart the colloctor to pickup the new configuration:
```
./collector.sh restart
```

6. Test you are receiving data with the follwing NRQL query:
```
from Metric select sum(system.cpu.time)  where newrelic.source = 'api.metrics.otlp' facet cpu, state
```

## Challenge 1: Configure your own host metric

Use the [OTel hostmetrics documentation]((https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/README.md)) to extend your collector configuration gather CPU *utilization* data.

> Hint: You will need to configure an additional metric scraper.

Test you have received the data withthe following query:
```
from Metric select latest(system.cpu.utilization) where newrelic.source = 'api.metrics.otlp' facet cpu,state  limit max
```

<details>
  <summary>Challenge 1 Solution</summary>

You can follow the documentation to view the configuration for [`system.cpu.utilization`](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/internal/scraper/cpuscraper/documentation.md#systemcpuutilization)

Adding this scraper simply involves adding it as an addintional configuration to the `metrics:` block in your hostmetrics configuration:

```
  ...
  hostmetrics:
    collection_interval: 30s
    scrapers:
      cpu:
        metrics:
          system.cpu.time:
            enabled: true  
          system.cpu.utilization:
            enabled: true
```
</details>



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