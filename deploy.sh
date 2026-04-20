#!/bin/bash

if [ -f ".env" ]; then
  echo "Loading environment variables from .env"
  set -a
  source .env
  set +a
else
  echo "Error: .env file not found!"
  exit 1
fi
else
  echo "Setting from GitHub Secrets"
  AZURE_APP_ID=${{ secrets.ACR_USERNAME }}
  AZURE_SECRET=${{ secrets.ACR_PASSWORD }}
  AZURE_TENANT_ID=${{ secrets.AZURE_TENANT_ID }}
  AZURE_SUBSCRIPTION_ID=${{ secrets.AZURE_SUBSCRIPTION_ID }}
  RESOURCE_GROUP=${{ secrets.RESOURCE_GROUP }}
  LOCATION=${{ secrets.LOCATION }}
  REGISTRY=${{ secrets.REGISTRY }}
  AKS_NAME=${{ secrets.AKS_NAME }}
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