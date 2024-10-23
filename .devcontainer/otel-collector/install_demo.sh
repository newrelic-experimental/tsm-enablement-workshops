#!/usr/bin/env bash
DEMOVERSION="20241002"

main() {
      # If the argument is empty then run both functions else only run provided function as argument $1.
      [ -z "$1" ] && { install_demo; } || $1     
   }

install_demo () {
    echo -e "\nInstalling demo, please wait...\n"
}

main "$@"
