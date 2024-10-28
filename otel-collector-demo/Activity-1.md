# Activity 1

The codespace already has an OpenTelemetry collector installed and ready to run. You will configure it by editing the configuration in `collector_config.yaml`.
This lab is made up of a number of Tasks and Challenges to help build your understanding of the collector architecture.

## Task 1: Configure the collector to send data to New Relic

An [exporter](https://github.com/open-telemetry/opentelemetry-collector/blob/main/exporter/README.md) defines how data leaves the collector. In order to view the data we need to export it to a New Relic account. To configure New Relic as a destination follow the following steps to set up an OTLP exporter:

> Note: You will see "nop" in the configuration. This is a placeholder for "no operation" to ensure the configuration is valid.

1. Configure environment variable for license key secret:

```
export NEW_RELIC_LICENSE_KEY=your_license_key
```

> Its good practice to not include sensitive values in your configuration. Providing them as env vars allows you to manage them seperately.



2. Add an OTLP exporter block to the `exporters:` section of [collector_config.yaml](collector_config.yaml)
Be sure to set the correct OTLP endpoint value. Note that we chose to name our exporter "newrelic" and we have removed the placeholder "nop" exporter

```
exporters:
  otlp/newrelic:
    endpoint: your_otel_endpoint_here
    headers:
      api-key: ${NEW_RELIC_LICENSE_KEY}
```

> The OTLP endpoint is dependent on your accounts data region and should include the port. [More information](https://docs.newrelic.com/docs/opentelemetry/best-practices/opentelemetry-otlp/)
> e.g.
> US endpoint  https://otlp.nr-data.net:4318
> EU endpoint https://otlp.eu01.nr-data.net:4318


3. Configure the services pipelines to use the New Relic exporter we just defined:

All the piplines currently export to "nop". Replace these with the value `otlp/newrelic`. This will cause all the trace, metric and logs piplines to deliver data to New Relic.

```
service:
  pipelines:
    traces:
      receivers: [nop]
      processors: []
      exporters: [otlp/newrelic]
    metrics:
      receivers: [nop]
      processors: []
      exporters: [otlp/newrelic]
    logs:
      receivers: [nop]
      processors: []
      exporters: [otlp/newrelic]
```

4. Test the configuration
You can start the collector and ensure that there are no errors reported in `collector.log`.

```
./collector.sh start
```

You can also  validate your configuration with:
```
./collector.sh validate
```

> You can view logs from the collector in `collector.log`

## Next up: Activity 2
You now have a working OTel collector! Continue with [Activity 2](Activity-2.md) to collect and ship some data.
