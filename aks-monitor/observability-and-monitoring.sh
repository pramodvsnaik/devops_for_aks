#!/bin/bash

source ./load-env.sh

while getopts "i:m:s:p:h:" opt; do
  case $opt in
    i)
      INSTALL=true
      ;;
    m)
      IMPORT=true
      ;;
    d)
      DELETE=true
      ;;
    s)
      SHOW=true
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
echo "IMPORT: $IMPORT"
echo "SHOW: $SHOW"
echo "PRACTICE: $PRACTICE"
echo "+++++++++++++++++++++++++++++++++++++"


if [ "$INSTALL" = true ]; then

az grafana folder create \
  --name ${GRAFANA_NAME} \
  --title AKS-Labs \
  --resource-group ${RESOURCE_GROUP}

fi

if [ "$IMPORT" = true ]; then
  clear
  echo "+++++++++++++++++++++++++++++++++++++"
  echo "Applying chaos policies on AKS cluster"
  echo "+++++++++++++++++++++++++++++++++++++"

  # import kube-apiserver dashboard
az grafana dashboard import \
  --name ${GRAFANA_NAME} \
  --resource-group ${RESOURCE_GROUP} \
  --folder 'AKS-Labs' \
  --definition 20331

# import etcd dashboard
az grafana dashboard import \
  --name ${GRAFANA_NAME} \
  --resource-group ${RESOURCE_GROUP} \
  --folder 'AKS-Labs' \
  --definition 20330

fi

if [ "$SHOW" = true ]; then
  clear
GRAFANA_UI=$(az grafana show \
  --name ${GRAFANA_NAME} \
  --resource-group ${RESOURCE_GROUP} \
  --query "properties.endpoint" -o tsv)

echo "Your Azure Managed Grafana is accessible at: $GRAFANA_UI"
fi