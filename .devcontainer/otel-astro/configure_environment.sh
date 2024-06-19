#!/usr/bin/env bash

main() {
    # If the argument is empty then run both functions else only run provided function as argument $1.
    [ -z "$1" ] && { build_frontend; download_images; } || $1     
}

build_frontend () {
   echo "\n Building frontend image, this may take while"
   cd /demo/scripts/ && docker compose build
   sudo rm -rf /demo
}

download_images () {

   declare -a arr=(
docker.io/nr-astro-otel-demo/local-frontend:latest
busybox:latest
ghcr.io/open-feature/flagd:v0.10.1
ghcr.io/open-telemetry/demo:1.10.0-accountingservice
ghcr.io/open-telemetry/demo:1.10.0-adservice
ghcr.io/open-telemetry/demo:1.10.0-cartservice
ghcr.io/open-telemetry/demo:1.10.0-checkoutservice
ghcr.io/open-telemetry/demo:1.10.0-currencyservice
ghcr.io/open-telemetry/demo:1.10.0-emailservice
ghcr.io/open-telemetry/demo:1.10.0-frauddetectionservice
ghcr.io/open-telemetry/demo:1.10.0-frontendproxy
ghcr.io/open-telemetry/demo:1.10.0-imageprovider
ghcr.io/open-telemetry/demo:1.10.0-kafka
ghcr.io/open-telemetry/demo:1.10.0-loadgenerator
ghcr.io/open-telemetry/demo:1.10.0-paymentservice
ghcr.io/open-telemetry/demo:1.10.0-productcatalogservice
ghcr.io/open-telemetry/demo:1.10.0-quoteservice
ghcr.io/open-telemetry/demo:1.10.0-recommendationservice
ghcr.io/open-telemetry/demo:1.10.0-shippingservice
newrelic/infrastructure-bundle:3.2.43
newrelic/k8s-events-forwarder:1.52.3
newrelic/k8s-metadata-injection:1.27.3
newrelic/newrelic-fluentbit-output:2.0.0
newrelic/nri-kube-events:2.9.9
newrelic/nri-kubernetes:3.28.8
otel/opentelemetry-collector-contrib:0.102.1
redis:7.2-alpine
registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.0
)

   for i in "${arr[@]}"
   do
      docker pull $i 
   done

}

main "$@"