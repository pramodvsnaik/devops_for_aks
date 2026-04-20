#!/bin/bash
clear

ResourceGroups=$(az group list \
 --subscription $AZURE_SUBSCRIPTION_ID --query "[*].name" -o tsv)

for ResourceGroup in $ResourceGroups
do
  echo "Deleting Resource Group: $ResourceGroup"
  az group delete --name $ResourceGroup --subscription $AZURE_SUBSCRIPTION_ID --yes 
done
