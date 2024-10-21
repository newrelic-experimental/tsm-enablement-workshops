# OTel Collector demo environment startup

Your environment is configured automatically at startup. This may take a few moments for the terminal to appear...

Please refer to the terminal instructions to provide necessary configuration for startup.

----

# Instructions

### Configure the collector endpoints

Configure your collector endpoint and New Relic license key as environment variables. This will cause the collector to send data to your New Relic account, you may wish to use a test account for this purpose.

```
export NEW_RELIC_LICENSE_KEY=your_license_key
export OTEL_EXPORTER_OTLP_ENDPOINT=your_otel_endpoint 
```

> The OTLP endpoint is dependent on your accounts data region. [More information](https://docs.newrelic.com/docs/opentelemetry/best-practices/opentelemetry-otlp/)
> e.g.
> US endpoint  https://otlp.nr-data.net:4318
> EU endpoint https://otlp.eu01.nr-data.net:4318


### Run the collector 

Use command below to start the collector:
```
./collector.sh start
```

Use command below to stop the collector:
```
./collector.sh stop
```

Use command below to restart the collector:
```
./collector.sh restart
```

> You can view debug logs from the collector in `collector.log`