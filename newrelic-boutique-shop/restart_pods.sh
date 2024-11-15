#!/usr/bin/env bash
echo -e "\nRestarting all pods\n"

kubectl delete pods --all -n store
kubectl wait pod -n store --for=condition=Ready --all --timeout 300s
kubectl --address 0.0.0.0 port-forward --pod-running-timeout=24h svc/frontend 3000:8081 -n store >> /dev/null &