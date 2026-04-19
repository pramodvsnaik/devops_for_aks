#!/bin/bash


set -a
source dva.env
set +a

echo "$AZURE_APP_ID"
echo "$AZURE_SECRET"
echo "$AZURE_TENANT_ID"

az login \
 --service-principal \
 -u "${{ secrets.ACR_USERNAME }}" \
 -p "${{ secrets.ACR_PASSWORD }}" \
 -t 'dda939ff-0d51-46fa-9b52-82fa3b976391'

az account set --subscription "${{ secrets.AZURE_SUBSCRIPTION_ID }}"

az group create \
 --name rg-cosmotal-dva \
 --location EastUS



az aks create \
 --resource-group rg-cosmotal-dva \
 --name myAKSCluster \
 --node-count 1 \
 --enable-addons monitoring \
 --generate-ssh-keys \
 --attach-acr cosmotal