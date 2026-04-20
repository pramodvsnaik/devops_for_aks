#!/bin/bash

set -a
source setting.env
set +a

echo "$AZURE_APP_ID"
echo "$AZURE_SECRET"
echo "$AZURE_TENANT_ID"

az login \
 --service-principal \
 -u $AZURE_APP_ID \
 -p $AZURE_SECRET \
 -t $AZURE_TENANT_ID -o none

az account set --subscription $AZURE_SUBSCRIPTION_ID

#az vm list-usage \
# --location eastus \
# --subscription $AZURE_SUBSCRIPTION_ID -o table
#az vm list-skus \
#  --location eastus \
#  --size Standard_D4d_v4 \
#  --all \
#  --output table

az vm list-skus \
  --location eastus \
  --resource-type virtualMachines \
  --size Standard_D4s_v3 \
  --query "[?capabilities[?name=='vCPUs']].{Name:name, Tier:tier, Size:capabilities[?name=='vCPUs'].value | [0]}" \
  --output table #--debug  2>&1 | tee -a output2.log

# az quota list \
# --location eastus \
# --subscription $AZURE_SUBSCRIPTION_ID */