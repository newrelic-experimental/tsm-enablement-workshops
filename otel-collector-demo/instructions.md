# OTel Collector demo environment startup

Your environment is configured automatically at startup. This may take a few moments for the terminal to appear...

Please refer to the terminal instructions to provide necessary configuration for startup.

----

# Instructions
Configure your collector endpoint and new relic license key as environment variables

> export NEW_RELIC_LICENSE_KEY=your_license_key
> export OTEL_EXPORTER_OTLP_ENDPOINT=your_otel_endpoint

Run the collector 

Use command below to start the collector
> ./collector.sh start

Use command below to stop the collector
> ./collector.sh stop

Use command below to restart the collector
> ./collector.sh restart