#!/usr/bin/env bash

main() {
    # If the argument is empty then run both functions else only run provided function as argument $1.
    [ -z "$1" ] && { start; } || $1     
}

start () {
   
   echo -e "\nStarting collector...\n"
   otelcol --config=collector_config.yaml > collector.log 2>&1 & 
   clear
   echo -e "\nCollector started..."
  
}

stop () {
   
   echo -e "\nStop collector...\n"
   pkill otelcol > collector.log 2>&1 & 
   clear
   echo -e "\nCollector stopped..."
  
}

restart () {
   
   echo -e "\nRestarting collector...\n"
   pkill otelcol > collector.log 2>&1 & 
   sleep 5
   otelcol --config=collector_config.yaml > collector.log 2>&1 & 
   clear
   echo -e "\nCollector restarted..."
}

validate(){
   res=$(otelcol validate --config=collector_config.yaml 2>&1 & )
   if [[ $res == "" ]]; then
      echo "No errors found"
   else
      echo $res
   fi
}

generate_log_entry () {
    uuid=$(uuidgen)
    echo "{\"uuid\":\"$uuid\",\"log\":\"INFO: [1] This data is just some generated data\",\"demo\":\"otel-collector-demo\",\"clientId\":\"112233\"}" >> custom.log 
    echo "{\"uuid\":\"$uuid\",\"log\":\"INFO: [2] Character name: Paddington Bear\",\"demo\":\"otel-collector-demo\",\"clientId\":\"112233\", \"price\": \"23.50\" }" >> custom.log 
    echo "{\"uuid\":\"$uuid\",\"log\":\"INFO: [3] Character name: Pooh Bear\",\"demo\":\"otel-collector-demo\",\"clientId\":\"112233\", \"price\": \"18.20\" }" >> custom.log 
    echo "{\"uuid\":\"$uuid\",\"log\":\"DEBUG: [4] This is a log line containing piidata in the form of a contact@newrelic.com email address\",\"stream\":\"stdout\",\"piidata\":\"123456789\",\"demo\":\"otel-collector-demo\",\"clientId\":\"112233\"}" >> custom.log  
    sleep 1
    echo "{\"uuid\":\"$uuid\",\"log\":\"INFO: [5] This line is delivered after a small delay\",\"demo\":\"otel-collector-demo\",\"clientId\":\"112233\"}" >> custom.log 
}

main "$@"