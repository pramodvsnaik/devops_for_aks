#!/bin/bash
echo "Registering AKS OIDC feature $PWD"
source ./load-env.sh

while getopts "i:c:d:p:h:" opt; do
  case $opt in
    i)
      INSTALL=true
      ;;
    c)
      CONNECT=true
      ;;
    d)
      DELETE=true
      ;;
    p)
      PRACTICE=true
      ;;
    h)
      CHAOS=true
      ;;
      *)
      echo "Usage: $0 -g <resource-group> -n <cluster-name> -l <location>"
      exit 1
      ;;
  esac
done
echo "+++++++++++++++++++++++++++++++++++++"
echo "INSTALL: $INSTALL"
echo "CONNECT: $CONNECT"
echo "DELETE: $DELETE"
echo "PRACTICE: $PRACTICE"
echo "+++++++++++++++++++++++++++++++++++++"
if [ "$INSTALL" = true ]; then
  echo "Installing AKS OIDC feature"
  az extension add --name aks-preview
  az feature register --namespace "Microsoft.ContainerService" --name "AdvancedNetworkingFlowLogsPreview"
  az feature register --namespace "Microsoft.ContainerService" --name "AdvancedNetworkingL7PolicyPreview"
  az feature register --namespace "Microsoft.ContainerService" --name "AdvancedNetworkingDynamicMetricsPreview"

echo "Creating Resource Group: $RESOURCE_GROUP"
az group create \
 --name "$RESOURCE_GROUP" \
 --location "$LOCATION"

az monitor account create \
 -g $RESOURCE_GROUP \
 -n $AZ_MONITOR_WORKSPACE \
 -l $LOCATION
# Create Log Analytics workspace
az monitor log-analytics workspace create \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $AZ_LOG_ANALYTICSWORKSPACE \
  --location $LOCATION

# Get Log Analytics workspace resource ID
LOG_ANALYTICS_ID=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $AZ_LOG_ANALYTICSWORKSPACE \
  --query id -o tsv)

echo ": LOG_ANALYTICS_ID: $LOG_ANALYTICS_ID"

AZ_MONITOR_ID=$(az monitor account show \
             -g $RESOURCE_GROUP \
             -n $AZ_MONITOR_WORKSPACE \
             --query id -o tsv)

echo ": AZ_MONITOR_ID: $AZ_MONITOR_ID"

az grafana create \
  --name $GRAFANA_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION

GRAFANA_ID=$(az grafana show \
  --name $GRAFANA_NAME \
  --resource-group $RESOURCE_GROUP \
  --query id -o tsv)

echo "GRAFANA_ID: $GRAFANA_ID"

sleep 10

az aks create \
  --name $AKS_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --pod-cidr 192.168.0.0/16 \
  --vm-size standard_d2_v4 \
  --tier standard \
  --max-pods 250 \
  --network-plugin azure \
  --network-plugin-mode overlay \
  --network-dataplane cilium \
  --generate-ssh-keys \
  --kubernetes-version 1.34 \
  --enable-acns \
  --enable-container-network-logs \
  --acns-advanced-networkpolicies L7 \
  --enable-addons monitoring \
  --enable-azure-monitor-metrics \
  --workspace-resource-id $LOG_ANALYTICS_ID \
  --azure-monitor-workspace-resource-id $AZ_MONITOR_ID \
  --grafana-resource-id /subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Dashboard/grafana/$GRAFANA_NAME

fi

if [ "$CONNECT" = true ]; then
  echo "Connecting to AKS cluster"
  az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME

  # Create the pet store namespace
kubectl create ns pets

# Deploy the pet store components to the pets namespace
kubectl apply -f https://raw.githubusercontent.com/Azure-Samples/aks-store-demo/main/aks-store-all-in-one.yaml -n pets
sleep 30
kubectl get pods -n pets
kubectl get svc -n pets
fi

if [ "$DELETE" = true ]; then
  echo "Deleting from AKS cluster"
  source ./cleanup.sh
fi


if [ "$PRACTICE" = true ]; then
  clear
  echo "+++++++++++++++++++++++++++++++++++++"
  echo "Practicing on AKS cluster"
  echo "+++++++++++++++++++++++++++++++++++++"
  
  curl -b acns-network-policy-fqdn.yaml https://raw.githubusercontent.com/Azure-Samples/aks-labs/refs/heads/main/docs/networking/assets/acns-network-policy-fqdn.yaml

  kubectl exec -n pets -it $(kubectl get po -n pets -l app=order-service -ojsonpath='{.items[0].metadata.name}') -c order-service  -- sh -c 'wget --spider --timeout=1 --tries=1 https://graph.microsoft.com'

  kubectl apply -n pets -f acns-network-policy-fqdn.yaml

  kubectl exec -n pets -it $(kubectl get po -n pets -l app=order-service -ojsonpath='{.items[0].metadata.name}') -c order-service  -- sh -c 'wget --spider --timeout=1 --tries=1 https://graph.microsoft.com'

fi


if [ "$CHAOS" = true ]; then
  clear
  echo "+++++++++++++++++++++++++++++++++++++"
  echo "Applying chaos policies on AKS cluster"
  echo "+++++++++++++++++++++++++++++++++++++"

curl -b acns-network-policy-chaos.yaml https://raw.githubusercontent.com/Azure-Samples/aks-labs/refs/heads/main/docs/networking/assets/acns-network-policy-chaos.yaml

kubectl apply -n pets -f acns-network-policy-chaos.yaml

fi