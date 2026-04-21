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

echo " Creating Vnet"
az network vnet create \
 --resource-group "$RESOURCE_GROUP" \
 --name "$VNET_NAME" \
 --address-prefixes "$VNET_ADDRESS_PREFIX" \
 --location "$LOCATION"

echo "Creating Subnet: $SUBNET_NAME"
az network vnet subnet create \
 --resource-group "$RESOURCE_GROUP" \
 --vnet-name "$VNET_NAME" \
 --name "$SUBNET_NAME" \
 --address-prefixes "$SUBNET_ADDRESS_PREFIX"

sleep 10

SUBNET_ID=$(az network vnet subnet show \
 --resource-group "$RESOURCE_GROUP" \
 --vnet-name "$VNET_NAME" \
 --name "$SUBNET_NAME" \
 --query id -o tsv)

echo "Subnet ID: $SUBNET_ID"


echo "Creating AKS Cluster: $AKS_NAME"
az aks create \
 --resource-group "$RESOURCE_GROUP" \
 --name "$AKS_NAME" \
 --node-count 1 \
 --generate-ssh-keys \
 --attach-acr "$REGISTRY" \
 --node-vm-size Standard_D2d_v4 \
 --vnet-subnet-id "$SUBNET_ID" \
 --service-cidr 172.20.0.0/16 \
 --dns-service-ip '172.20.0.10' \
 --pod-cidr '10.244.0.0/16'


echo "Creating mysql flexible-server"

az mysql flexible-server create \
    --admin-user myadmin \
    --admin-password $MYSQL_ADMIN_PASSWORD \
    --name $MYSQL_SERVER_NAME \
    --resource-group $RESOURCE_GROUP


 az mysql flexible-server db create \
     --server-name $MYSQL_SERVER_NAME \
     --resource-group $RESOURCE_GROUP \
     -d $DATABASE_NAME

 az mysql flexible-server firewall-rule create \
     --rule-name allAzureIPs \
     --name $MYSQL_SERVER_NAME \
     --resource-group $RESOURCE_GROUP \
     --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0