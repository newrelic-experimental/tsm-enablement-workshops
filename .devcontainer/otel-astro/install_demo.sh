#!/usr/bin/env bash

main() {
    # If the argument is empty then run both functions else only run provided function as argument $1.
    [ -z "$1" ] && { create_cluster; deploy_demo; } || $1     
}

create_cluster () {
   echo -e "\nCreating your cluster, please wait..."
   helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts >> /dev/null
   helm repo update >> /dev/null
   minikube start --cpus 3 --memory 6144 --wait all
   minikube update-context
   echo -e "\nCluster created!"
}

deploy_demo () {
   
   while true; do
      echo -e "\nEnter your ingest license key: "
      read -t 60 licenseKey
      if [ -z $licenseKey ]; then
         echo -e "License Key can't be empty!"
         continue
      fi
      break
   done

   while true; do
      echo -e "\nSpecigy your New Relic datacenter: [US/EU]"
      read -t 60 datacenter
      if [ -z $datacenter ]; then
         echo -e "You need to choose a datacenter"
         continue
      fi
      break
   done


   echo -e "\nInstalling Otel application stack demo..."
   kubectl create secret generic newrelic-key-secret --save-config --dry-run=client --from-literal=new_relic_license_key=$licenseKey -o yaml | kubectl apply -f - 2>&1
   if [[  $(echo $datacenter | tr '[:upper:]' '[:lower:]') ==  "eu" ]]; then
      helm upgrade --install newrelic-otel open-telemetry/opentelemetry-demo --values ./values.yaml --set opentelemetry-collector.config.exporters.otlp.endpoint="otlp.eu01.nr-data.net:4318" >> /dev/null
   else
      helm upgrade --install newrelic-otel open-telemetry/opentelemetry-demo --values ./values.yaml >> /dev/null
   fi

   echo -e "Demo installed, waiting for all pods to be ready..."
   sleep 3
   run_with_dots kubectl wait --for=condition=Ready pods --all --timeout=10m 2>&1
   echo -e "All pods ready"
   sleep 3
   kubectl --address 0.0.0.0 port-forward --pod-running-timeout=24h svc/newrelic-otel-frontendproxy 3000:8080 >> /dev/null &
   gh codespace edit -c $CODESPACE_NAME -d 'newrelic-otel-astroshop'
   gh codespace ports visibility 3000:public -c $CODESPACE_NAME
   clear
   echo -e "Access frontend via "https://$CODESPACE_NAME-3000.app.github.dev/""
}

run_with_dots () {
   "$@" &

   while kill -0 $!; do
      clear
      echo -e "Waiting for all pods to be ready, this can a few minutes, please wait...\n\n"
      kubectl get pods > /dev/tty
      sleep 3
   done
   printf '\n' > /dev/tty

}

main "$@"



