#!/usr/bin/env bash
DEMOVERSION="20241118"

main() {
   # Check if the script has been run before
   if [ -f "firstrun.txt" ]; then
       echo -e "\n\nInstall script already run. Delete /firstrun.txt to re-run installation." 
       echo -e "\n\nRestarting minikube, this may take while please wait..."
       minikube start
       echo -e "\nWaiting for pods to be ready, this can take while, please wait..."
       kubectl delete pods -n store --all > /dev/null
       sleep 3
       wait_for_pods
       echo -e "\nChecking frontend is ready to serve\n"
       # Double check frontend is ready to serve, or send error to terminal
       kubectl wait pod --for=condition=Ready -l app=frontend -n store
       clear

      if [ -d "/workspace" ]; then
         kubectl --address 0.0.0.0 port-forward --pod-running-timeout=24h svc/frontend 3000:8081 -n store >> /dev/null &
         echo -e "\nAccess frontend via "https://$CODESPACE_NAME-3000.app.github.dev/""
      else
         kubectl --address 0.0.0.0 port-forward --pod-running-timeout=24h svc/frontend 8081:8081 -n store >> /dev/null &
         echo -e "\nAccess frontend via "http://your-vm-ip:8081""
      fi

   sleep 3
    else
      # If the argument is empty then run both functions else only run provided function as argument $1.
      touch firstrun.txt
      [ -z "$1" ] && { create_cluster; deploy_demo; } || $1     
    fi
  
}

create_cluster () {
   echo -e "\nUpdating helm repos"
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
      echo -e "\nEnter your account ID: "
      read -t 60 accountId
      if [ -z "$accountId" ]; then
         echo -e "$accountId can't be empty"
         continue
      fi
      break
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

   while true; do
       BROWSER_FILE="browseragent.js"
       
       if [ -s "$BROWSER_FILE" ]; then
         # The file is not-empty.
         repl=$(<$BROWSER_FILE)
         str="NEWRELIC_BROWSER_AGENT"
         temp_file=$(mktemp)
         while IFS= read -r line; do
         echo "${line//$str/$repl}" >> "$temp_file"
         done < ./frontend_image/header.html
         mv "$temp_file" ./frontend_image/header.html
         echo -e "\nBrowser agent file has been updated"
         break
      else
         # The file is empty.
         echo -e "\nPlease add New Relic browser script to browseragent.js"
         sleep 15
      fi
   done


   if  [[ $licenseKey == eu* ]];  then 
      echo -e "\nLicense key is for EU datacenter"
      echo -e "\nWill deploy to EU datacenter"
      datacenter="eu"
   else
      echo -e "\nLicense key is for US datacenter"
      echo -e "\nWill deploy to US datacenter"
      datacenter="us"
   fi



   # install site
   git clone https://github.com/maralski/microservices-demo
   cd microservices-demo/
   echo -e "\nInstalling boutique shop demo\n"
   export NEW_RELIC_LICENSE_KEY=$licenseKey; ./deploy
   build_frontend 
   kubectl patch deployment frontend -n store --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/imagePullPolicy", "value": "Never"}]' >> /dev/null
   kubectl set image deployment/frontend frontend=onlineboutique-local-frontend:latest -n store >> /dev/null
   kubectl set image deployment/productcatalogservice productcatalogservice=jbuchanan122/onlineboutique-productcatalogservice -n store >> /dev/null
   echo "Demo app installed"

   echo -e "\nInstalling New Relic kubernetes integration\n"
   cd /workspace
   helm upgrade --install newrelic-bundle newrelic/nri-bundle  --version 5.0.81 --set global.licenseKey=$licenseKey --namespace=newrelic --create-namespace --values ./newrelic_values.yaml >> /dev/null
   echo -e "\nNew Relic kubernetes deployed" 

   # Deploy heartbeat mechanism
   if [ -d "/workspace" ]; then
      hbselfhosted="false"
   else
      hbselfhosted="true"
   fi

   hbdemo="nr-boutique-shop-demo"
   hbstarttime=$(date +%s)
   hbhostversion=$(. /etc/os-release; echo "$VERSION" | tr -d '[:blank:]')
   hbhostname=$(. /etc/os-release; echo "$NAME" | tr -d '[:blank:]')
   hbaccountid=$( echo "$accountId" | tr -d '[:blank:]')
   # Applies if does not exist or warns if exists, this is intentional to avoid uid being replaced on each time it runs
   kubectl create configmap nrheartbeat --from-literal=hbaccountid=$hbaccountid --from-literal=hbdemoversion=$DEMOVERSION --from-literal=hbuid=$(uuidgen) --from-literal=hbhostversion=$hbhostversion --from-literal=hbhostname=$hbhostname --from-literal=hbselfhosted=$hbselfhosted --from-literal=hbstarttime=$hbstarttime --from-literal=hbdemo=$hbdemo
   kubectl apply -f ./hbcronjob.yaml


   echo -e "\nBoutique Shop demo deployed"

   echo -e "\nWaiting for pods to be ready, this can take while, please wait..."
   sleep 3
   wait_for_pods
   sleep 3
   clear
   echo -e "\nChecking frontend is ready to serve\n"
   # Double check frontend is ready to serve, or send error to terminal
   kubectl wait pod --for=condition=Ready -l app=frontend -n store



   if [ -d "/workspace" ]; then
      kubectl --address 0.0.0.0 port-forward --pod-running-timeout=24h svc/frontend 3000:8081 -n store >> /dev/null &
      gh codespace edit -c $CODESPACE_NAME -d 'nr-boutique-shop-demo'
      gh codespace ports visibility 3000:public -c $CODESPACE_NAME
      clear
      echo -e "\nAccess frontend via "https://$CODESPACE_NAME-3000.app.github.dev/""
   else
      kubectl --address 0.0.0.0 port-forward --pod-running-timeout=24h svc/frontend 8081:8081 -n store >> /dev/null &
      clear
      echo -e "\nAccess frontend via "http://your-vm-ip:8081""
   fi

}

build_frontend () {

   # Build frontend image
   clear
   echo -e "\nBuilding frontend image\n"
   kubectl scale deployment frontend --replicas=0 -n store >> /dev/null
   frontendpods=$(kubectl get pods -n store -l app=frontend -o name | wc -l | tr -d ' ')
   while [[ $frontendpods -gt 0 ]];do
      frontendpods=$(kubectl get pods -n store -l app=frontend -o name | wc -l | tr -d ' ')
      echo -e "\nPlease wait\n"
      sleep 5
   done
   cd /workspace/frontend_image
   eval $(minikube docker-env)
   docker build . -t onlineboutique-local-frontend:latest --no-cache &> /dev/null
   cd .. 
   kubectl scale deployment frontend --replicas=1 -n store >> /dev/null
   echo -e "\nFrontend image built and deployed\n"
   eval $(minikube docker-env -u)
   clear 
   

}


wait_for_pods () {
   currentnumberfailedpods=$(kubectl get pods -n store -o json | jq -r '.items[] | select(.status.containerStatuses[]?.ready == false) | .metadata.name' | wc -l | tr -d ' ')
   
   while [ $currentnumberfailedpods -gt 0 ]; do
      clear
      kubectl get pods -n store
      currentnumberfailedpods=$(kubectl get pods -n store -o json | jq -r '.items[] | select(.status.containerStatuses[]?.ready == false) | .metadata.name' | wc -l | tr -d ' ')

      echo -e "\nNot all pods in ready state yet, waiting for $currentnumberfailedpods pods to be ready"
      sleep 2
   done
   clear
   echo -e "\nAll pods ready!!!"
}

main "$@"
