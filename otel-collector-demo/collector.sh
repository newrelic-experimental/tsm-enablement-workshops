#!/usr/bin/env bash

main() {
    # If the argument is empty then run both functions else only run provided function as argument $1.
    [ -z "$1" ] && { start; } || $1     
}

start () {
   
   echo -e "\nStarting collector...\n"
   otelcol --config=customconfig.yaml > collector.log 2>&1 & 
   clear
   echo -e "\nCollector started..."
  
}

stop () {
   
   echo -e "\nStop collector...\n"
   pkill otelcol > collector.log 2>&1 & 
   clear
   echo -e "\nCollector stoped..."
  
}

restart () {
   
   echo -e "\nRestarting collector...\n"
   pkill otelcol > collector.log 2>&1 & 
   sleep 5
   otelcol --config=customconfig.yaml > collector.log 2>&1 & 
   clear
   echo -e "\nCollector restarted..."
}

validate(){
   res=$(otelcol validate --config=customconfig.yaml 2>&1 & )
   if [[ $res == "" ]]; then
      echo "No errors found"
   else
      echo $res
   fi
}

generate_log_entry () {
    for run in {1..5}; do
    echo '{"log":"INFO: This is a log line containing piidata","stream":"stdout","piidata":"123456789"}' >> custom.log 
    done  
}

main "$@"