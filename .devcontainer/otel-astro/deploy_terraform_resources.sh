#!/usr/bin/env bash

main() {
    # If the argument is empty then run both functions else only run provided function as argument $1.
    [ -z "$1" ] && { deploy_tf; } || $1     
}

deploy_tf () {
      while true; do
      echo -e "\nEnter your user license key: "
      read -t 60 licenseKey
      if [ -z $licenseKey ]; then
         echo -e "\nUser License Key can't be empty"
         continue
      fi
      break
      done

      while true; do
      echo -e "\nEnter your account Id: "
      read -t 60 accountid
      if [ -z $accountid ]; then
         echo -e "\nAccount Id can't be empty"
         continue
      fi
      break
      done

      while true; do
         echo -e "\nSpecify your New Relic datacenter: [US/EU]"
         read -t 60 datacenter
         if [ -z $datacenter ]; then
            echo -e "You need to choose a datacenter"
            continue
         fi
         break
      done


      echo -e "\nDeploying Terraform resources"
      export NEW_RELIC_API_KEY=$licenseKey
      export NEW_RELIC_ACCOUNT_ID=$accountid
      export NEW_RELIC_REGION=$datacenter
      terraform init
      terraform apply -auto-approve
      echo -e "\nTerraform resources deployed"

}
main "$@"