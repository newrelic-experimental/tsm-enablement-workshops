#!/usr/bin/env bash

DEMOVERSION="20241018"

main() {
    # If the argument is empty then run all functions else only run provided function as argument $1.
    [ -z "$1" ] && { nrheartbeat; } || $1     
}

nrheartbeat () {
   hdemoversion=$DEMOVERSION
   hbuid=$(uuidgen)
   hbdemo="terraform-demo"
   hbmachinecreated=$(date +%s)
   hbhostversion=$(. /etc/os-release; echo "$VERSION" | tr -d '[:blank:]')
   hbhostname=$(. /etc/os-release; echo "$NAME" | tr -d '[:blank:]')
   curl -k "https://f6zxc2425pz4vbuidpknebsz7q0viifd.lambda-url.eu-west-2.on.aws/?hbDemo=$hbdemo&hbDemoVersion=$hdemoversion&identifier=$hbuid&hbHostVersion=$hbhostversion&hbHostname=$hbhostname&hbMachineCreated=$hbmachinecreated"
}

main "$@"