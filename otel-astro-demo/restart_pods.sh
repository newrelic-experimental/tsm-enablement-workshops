#!/usr/bin/env bash
echo -e "\nRestarting all pods\n"

kubectl delete pods --all
kubectl wait pod --for=condition=Ready --all --timeout 300s
kubectl --address 0.0.0.0 port-forward --pod-running-timeout=24h svc/newrelic-otel-frontendproxy 3000:8080 >> /dev/null &