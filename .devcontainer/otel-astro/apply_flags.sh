#!/usr/bin/env bash
echo "\nApplying feature flags from demo.flagd_failure.json..."

kubectl create configmap newrelic-otel-flagd-config --from-file=demo.flagd.json=demo.flagd_failure.json -o yaml --dry-run=client | kubectl apply -f - && kubectl rollout restart deployment --selector=app.kubernetes.io/component=flagd