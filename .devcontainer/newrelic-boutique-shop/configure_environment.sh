#!/usr/bin/env bash

main() {
    # If the argument is empty then run both functions else only run provided function as argument $1.
    [ -z "$1" ] && { create_cluster; } || $1     
}

create_cluster () {
   
   echo -e "\nCreating your cluster, please wait...\n"
   minikube start --cpus no-limit --memory no-limit --wait apiserver
   echo -e "\nBuilding images cache"
   declare -a arr=(
busybox:latest
pmarelas288/adservice
pmarelas288/cartservice
pmarelas288/checkoutservice
pmarelas288/currencyservice
pmarelas288/emailservice
jbuchanan122/onlineboutique-frontend
pmarelas288/loadgenerator
pmarelas288/paymentservice
jbuchanan122/onlineboutique-productcatalogservice
pmarelas288/recommendationservice
pmarelas288/shippingservice
redis:alpine
newrelic/infrastructure-bundle:3.2.43
newrelic/k8s-events-forwarder:1.52.3
newrelic/k8s-metadata-injection:1.27.3
newrelic/newrelic-fluentbit-output:2.0.0
newrelic/nri-kube-events:2.9.9
newrelic/nri-kubernetes:3.28.8
registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.10.0
curlimages/curl
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