# Feature flags
The demo uses feature flags to trigger perfromance degradation scenarios. 

To enable/disable the flags edit the [demo.flagd_failure.json](demo.flagd_failure.json) file and restart the flagd service by running the following command in the terminal:

> ./apply_flags.sh

For information on what feature flags do consult the demo documentation: https://opentelemetry.io/docs/demo/feature-flags/