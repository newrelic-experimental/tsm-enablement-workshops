#!/usr/bin/env bash

main() {
    # If the argument is empty then run both functions else only run provided function as argument $1.
    [ -z "$1" ] && { create_cluster; deploy_demo; } || $1     
}

create_cluster () {
   echo -e "\nUpdating helm repos"
   helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts >> /dev/null
   helm repo add newrelic https://helm-charts.newrelic.com >> /dev/null
   helm repo update >> /dev/null
   echo -e "\nRepos updated"
   echo -e "\nChecking minikube status"

   minikubestatus=$(docker container inspect minikube --format={{.State.Status}} 2>&1 | tr -d '\n')
   if test "$minikubestatus" == "exited"; then
      echo -e "\nMinikube current status is $minikubestatus"
      echo -e "\nMinikube was not running, restarting it"
      minikube start
   elif test "$minikubestatus" == "running"; then
      echo -e "\nMinikube current status is $minikubestatus"
      echo -e "\nMinikube already running, no action required"
   else
      # pre build must have failed, create cluster now
      echo -e "\nMinikube not running"
      echo -e "\nCreating your cluster, please wait...\n"
      minikube start --cpus no-limit --memory no-limit --wait apiserver
      echo -e "\nCluster created!"
   fi
   echo -e "\nCluster ready"
}

deploy_demo () {

   while true; do
      echo -e "\nUse New Relic k8s integration or OTEL aka NRDOT? [nr/otel]"
      read -t 60 k8smonitoringtype
      if [ -z $k8smonitoringtype ]; then
         echo -e "\nK8s monitoring type can't be empty"
         continue
      fi
      break
   done

   while true; do
       if [ -s /workspace/browseragent.js ]; then
         # The file is not-empty.
         sed -i '/<script type="text\/javascript">/g' /workspace/browseragent.js
         sed -i '/<\/script>/g' /workspace/browseragent.js
         echo -e "\nBrowser agent file has been updated"
         kubectl create configmap newrelic-otel-browseragent --from-file=browseragent.js=browseragent.js -o yaml --dry-run=client | kubectl apply -f -
         break
      else
         # The file is empty.
         echo -e "\nPlease add New Relic browser script to browseragent.js"
         sleep 15
      fi
   done

   while true; do
      echo -e "\nEnter your ingest license key: "
      read -t 60 licenseKey
      if [ -z $licenseKey ]; then
         echo -e "\nLicense Key can't be empty"
         continue
      fi
      break
   done


   if  [[ $licenseKey == eu* ]]  then 
      echo -e "\nLicense key is for EU datacenter"
      echo -e "\nWill deploy to EU datacenter"
      datacenter="eu"
   else
      echo -e "\nLicense key is for US datacenter"
      echo -e "\nWill deploy to US datacenter"
      datacenter="us"
   fi

   if [[  $(echo $k8smonitoringtype | tr '[:upper:]' '[:lower:]') ==  "otel" ]]; then
      echo -e "\nInstalling New Relic OTEL kubernetes integration\n"
      helm upgrade --install nr-k8s-otel-collector newrelic/nr-k8s-otel-collector --version 0.7.1 --namespace=default --set licenseKey=$licenseKey --values ./nrdot.yaml
      echo -e "\nNew Relic OTEL kubernetes deployed"
   else
      echo -e "\nInstalling New Relic kubernetes integration\n"
      helm upgrade --install newrelic-bundle newrelic/nri-bundle  --version 5.0.81 --set global.licenseKey=$licenseKey --namespace=default --values ./newrelic_values.yaml
      echo -e "\nNew Relic kubernetes deployed"
   fi

   echo -e "\nInstalling otel demo\n"
   kubectl create secret generic newrelic-key-secret --save-config --dry-run=client --from-literal=new_relic_license_key=$licenseKey -o yaml | kubectl apply -f - 2>&1
   

   if [[  $(echo $datacenter | tr '[:upper:]' '[:lower:]') ==  "eu" ]]; then
      helm upgrade --install newrelic-otel open-telemetry/opentelemetry-demo --values ./otel_values.yaml --version 0.31.0 --set opentelemetry-collector.config.exporters.otlp.endpoint="otlp.eu01.nr-data.net:4318" >> /dev/null
   else
      helm upgrade --install newrelic-otel open-telemetry/opentelemetry-demo --values ./otel_values.yaml --version 0.31.0 >> /dev/null
   fi

   echo -e "\nOTEL demo deployed"

   echo -e "\nWaiting for pods to be ready, this can take while, please wait..."
   sleep 3
   wait_for_pods
   sleep 3
   clear
   echo -e "\nChecking frontend is ready to serve\n"
   #Double check frontend is ready to serve, or send error to terminal
   kubectl wait pod --for=condition=Ready -l app.kubernetes.io/component=frontend
   kubectl --address 0.0.0.0 port-forward --pod-running-timeout=24h svc/newrelic-otel-frontendproxy 3000:8080 >> /dev/null &
   gh codespace edit -c $CODESPACE_NAME -d 'newrelic-otel-astroshop'
   gh codespace ports visibility 3000:public -c $CODESPACE_NAME
   clear
   echo -e "\nAccess frontend via "https://$CODESPACE_NAME-3000.app.github.dev/""
}


wait_for_pods () {
   if [[  $(echo $k8smonitoringtype | tr '[:upper:]' '[:lower:]') ==  "otel" ]]; then
      declare -i numberpodsexpected=22
   else
      declare -i numberpodsexpected=25
   fi
   declare -i currentnumberpods=0
   
   while [[ $numberpodsexpected -ge $currentnumberpods ]];do
      clear
      kubectl get pods
      echo -e "\nNumber of expected pods in running state needs to exceed: $numberpodsexpected"
      currentnumberpods=$(kubectl get pods --field-selector=status.phase!=Succeeded,status.phase=Running --output name | wc -l | tr -d ' ')
      echo -e "\nCurrent number of pods in running state: $currentnumberpods"
      sleep 5
   done
   sleep 2
   clear
   echo -e "\n All pods ready!!!"
}

main "$@"