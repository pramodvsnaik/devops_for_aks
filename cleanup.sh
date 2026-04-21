#!/bin/bash
clear

ResourceGroups=$(az group list \
 --subscription e313f3ee-c77e-4d07-887b-7584aba6b548 --query "[*].name" -o tsv)

for ResourceGroup in $ResourceGroups
do
  echo "Deleting Resource Group: $ResourceGroup"
  az group delete --name $ResourceGroup --subscription e313f3ee-c77e-4d07-887b-7584aba6b548 --yes 
done
