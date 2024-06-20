#!/usr/bin/env bash
echo -e "\nApplying feature flags from demo.flagd_failure.json...\n"

kubectl delete configmap newrelic-otel-flagd-config && echo -e "" && kubectl create configmap newrelic-otel-flagd-config --from-file=demo.flagd.json=demo.flagd_failure.json -o yaml --dry-run=client | kubectl apply -f - 

echo -e "\nConfiguration applied, please wait as this can take up to a minute to take effect\n"