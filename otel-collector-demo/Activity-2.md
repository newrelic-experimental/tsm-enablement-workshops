# Activity 2

## Task 1: Add a receiver to collect host CPU metrics 

Receivers allow the collector to receive data. There are numerous receivers available for many different sources. For this example we want to gather CPU metrics. The "hostmetrics" receiver can provide this data. Read more about the [hostmetrics receiver here](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/README.md).

To add the hostmetrics receiver to your collector do the following:

1. Review the documentation for [hostmetrics](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/README.md)
2. Add a `hostmetric` block to the `receivers` section of [collector_config.yaml](collector_config.yaml)
3. Set the collection interval to 30 seconds and add a `system.cpu.time` scraper as below:

```
receivers:
  nop:
  hostmetrics:
    collection_interval: 30s
    scrapers:
      cpu:
        metrics:
          system.cpu.time:
            enabled: true
```

The receiver is configured, but we need to configure where the received data is sent. The hostmetrics receiver generates metrics, so we need to configure the `metrics` pipeline to receive metrics from `hostmetrics` receiver.

4. Update the metrics pipeline receiver to utilise the `hostmetrics` receiver (remove `nop`):

```
service:
  pipelines:
    traces:
      receivers: [nop]
      processors: []
      exporters: [otlp/newrelic]
    metrics:
      receivers: [hostmetrics]
      processors: []
      exporters: [otlp/newrelic]
    logs:
      receivers: [nop]
      processors: []
      exporters: [otlp/newrelic]
```

5. Restart the collector to pickup the new configuration:
```
./collector.sh restart
```

6. Test you are receiving data with the follwing NRQL query:
```
from Metric select sum(system.cpu.time)  where newrelic.source = 'api.metrics.otlp' facet cpu, state
```

## Challenge 1: Configure your own host metric

Use the [OTel hostmetrics documentation](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/README.md) to extend your collector configuration gather CPU *utilization* data.

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



##  TASK 2: Filtering metrics with a processor
You may have noticed that the hostmetrics CPU scraper gathers data for multiple states of each cpu such as `idle`, `user`, `system`, `interrupt`, etc. Some of these states don't offer us much value so lets filter these out to save on ingest overheads.

We can use [OTel Processors](https://github.com/open-telemetry/opentelemetry-collector/blob/main/processor/README.md) to manipulate the data running through the OTel collector pipeline. As with receivers there are multiple processors available to choose from. For this example we will use the standard [Filter Processor](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/processor/filterprocessor/README.md)

For this example lets remove the states "interrupt", "nice" and "softirq" from our CPU utilization data:

1. Add a new `filter` configuration block to the `processors:` section of the configuration. We should name this configuration so we can reference it later by following the type name with `/[name]`, for instance: `filter/exclude_cpu_states:`
2. Add a metric datapoint configuration for each state to drop as follows:

```
processors:
  filter/exclude_cpu_states:
    metrics:
      datapoint:
        - 'metric.name == "system.cpu.utilization" and attributes["state"] == "interrupt"'
        - 'metric.name == "system.cpu.utilization" and attributes["state"] == "nice"'
        - 'metric.name == "system.cpu.utilization" and attributes["state"] == "softirq"'
```

3. As this data is metric data, we need to add the processor we just created to the metrics pipeline processors list:

```
service:
  pipelines:
    traces:
      receivers: [nop]
      processors: []
      exporters: [otlp/newrelic]
    metrics:
      receivers: [hostmetrics]
      processors: [filter/exclude_cpu_states]
      exporters: [otlp/newrelic]
    logs:
      receivers: [nop]
      processors: []
      exporters: [otlp/newrelic]
```

4. Restart collector to pickup the configuration:
```
./collector.sh restart
```

5. Check the in New Relic states have been correctly removed from recent data:
```
from Metric select latest(system.cpu.utilization) where newrelic.source = 'api.metrics.otlp' facet cpu,state limit max since 2 minutes ago
```

## Challenge 2: Filter all CPU metrics
Our filter currently filters out the undesired states from the `system.cpu.utilization metric`, but those states are still being ingested for the `system.cpu.time` metric. Reconfigure the filter processor so that the states are removed from *all* system.cpu.* metrics.

> Hint: You may find browsing the [OpenTelemetry transform language](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/pkg/ottl/ottlfuncs/README.md) documentation for available functions  that supports a regular expression useful here.

<details>
  <summary>Challenge 2 Solution</summary>

Here is one solution. We use the [IsMatch()](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/pkg/ottl/ottlfuncs/README.md#ismatch) function to wildcard both the metric name and also to refactor the list of states:

```
processors:
  filter/exclude_cpu_states:
    metrics:
      datapoint:
        - 'IsMatch(metric.name, "system.cpu.*") and IsMatch(attributes["state"], "^(interrupt|nice|softirq)$")'
```
</details>


## Next Step: Activity 3

You've successfully collected, processed and shipped some data. Continue to [Activity 3](Activity-3.md) to learn how to ship and maniuplate logs.

> If you had trouble, the full solution for this activity can be found [here](./solutions/Activity-2-solution.yaml)