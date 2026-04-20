#!/bin/bash

if [ -f ".env" ]; then
  echo "Loading environment variables from .env"
  set -a
  source .env
  set +a
else
  echo "Error: .env file not found!"
  echo "Setting from GitHub Secrets"

fi

echo "$AZURE_APP_ID"
echo "$AZURE_SECRET"
echo "$AZURE_TENANT_ID"

az login \
 --service-principal \
 -u "$AZURE_APP_ID" \
 -p "$AZURE_SECRET" \
 -t "$AZURE_TENANT_ID" -o none

az account set --subscription "$AZURE_SUBSCRIPTION_ID"

echo "Creating Resource Group: $RESOURCE_GROUP"
az group create \
 --name "$RESOURCE_GROUP" \
 --location "$LOCATION"

echo "Creating ACR: $REGISTRY"
az acr create \
 --resource-group "$RESOURCE_GROUP" \
 --name "$REGISTRY" \
 --sku Basic

echo "Creating AKS Cluster: $AKS_NAME"
az aks create \
 --resource-group "$RESOURCE_GROUP" \
 --name "$AKS_NAME" \
 --node-count 1 \
 --enable-addons monitoring \
 --generate-ssh-keys \
 --attach-acr "$REGISTRY" \
 --vm-size Standard_D2d_v4