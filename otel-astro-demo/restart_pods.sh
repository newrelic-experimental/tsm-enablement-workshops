#!/usr/bin/env bash
echo -e "\nRestarting all pods\n"

kubectl delete pods --all
kubectl wait pod --for=condition=Ready --all --timeout 300s