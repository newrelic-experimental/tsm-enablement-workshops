#!/usr/bin/env bash

main() {
    # If the argument is empty then run both functions else only run provided function as argument $1.
    [ -z "$1" ] && { build_frontend; create_cluster; } || $1     
}

build_frontend () {
   echo "\n Building frontend image, this may take while"
   cd /demo/scripts/ && docker compose build
   sudo rm -rf /demo
}

create_cluster () {
   
   echo -e "\nCreating your cluster, please wait...\n"
   minikube start --cpus no-limit --memory no-limit --wait apiserver
   echo -e "\nBuilding images cache"
   declare -a arr=(
docker.io/nr-astro-otel-demo/local-frontend:latest
busybox
busybox:latest
curlimages/curl
gcr.io/k8s-minikube/storage-provisioner:v5
ghcr.io/open-feature/flagd:v0.11.1
ghcr.io/open-telemetry/demo:1.12.0-accountingservice
ghcr.io/open-telemetry/demo:1.12.0-adservice
ghcr.io/open-telemetry/demo:1.12.0-cartservice
ghcr.io/open-telemetry/demo:1.12.0-checkoutservice
ghcr.io/open-telemetry/demo:1.12.0-currencyservice
ghcr.io/open-telemetry/demo:1.12.0-emailservice
ghcr.io/open-telemetry/demo:1.12.0-flagdui
ghcr.io/open-telemetry/demo:1.12.0-frauddetectionservice
ghcr.io/open-telemetry/demo:1.12.0-frontendproxy
ghcr.io/open-telemetry/demo:1.12.0-imageprovider
ghcr.io/open-telemetry/demo:1.12.0-kafka
ghcr.io/open-telemetry/demo:1.12.0-loadgenerator
ghcr.io/open-telemetry/demo:1.12.0-paymentservice
ghcr.io/open-telemetry/demo:1.12.0-productcatalogservice
ghcr.io/open-telemetry/demo:1.12.0-quoteservice
ghcr.io/open-telemetry/demo:1.12.0-shippingservice
newrelic/otel-demo:1.11.0-recommendationservice
otel/opentelemetry-collector-contrib:0.114.0
registry.k8s.io/coredns/coredns:v1.11.3
registry.k8s.io/etcd:3.5.16-0
registry.k8s.io/kube-apiserver:v1.32.0
registry.k8s.io/kube-controller-manager:v1.32.0
registry.k8s.io/kube-proxy:v1.32.0
registry.k8s.io/kube-scheduler:v1.32.0
registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.0
registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.11.0
valkey/valkey:7.2-alpine
newrelic/k8s-events-forwarder:1.60.1
newrelic/k8s-metadata-injection:1.27.3
redis:7.2-alpine
newrelic/infrastructure-bundle:3.2.63
newrelic/k8s-metadata-injection:1.31.1
newrelic/newrelic-fluentbit-output:2.1.0
newrelic/nr-otel-collector:0.8.10
newrelic/nri-kube-events:2.11.6
newrelic/nri-kubernetes:3.33.1
)

   for i in "${arr[@]}"
   do
      echo -e "\nPulling image $i from remote registry\n"
      minikube image load $i
      echo -e "\nPushed image $i to minikube\n"
   done

   minikube stop
}

main "$@"