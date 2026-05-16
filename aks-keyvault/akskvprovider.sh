#!/bin/bash

source ../scripts/load-env.sh

az aks enable-addons \
  --addons azure-keyvault-secrets-provider \
  --name ${AKS_NAME} \
  --resource-group ${RESOURCE_GROUP}

KV_JSON=$(az resource list \
     --resource-group ${RESOURCE_GROUP} \
     --resource-type Microsoft.KeyVault/vaults \
     --query "[0].{name:name , id:id}" \
     -o json )

echo "Found $KV_JSON"

if [ -z "$KV_JSON" ]; then

  KV_JSON=$(az keyvault create \
    --name "$AKV_NAME$(date +%M%S)" \
    -g ${RESOURCE_GROUP} \
    -l ${LOCATION} \
    --enable-rbac-authorization \
    --query "{name:name , id:id}" \
    -o json)

  echo "Keyvault New : $KV_JSON"

  KVNAME=$(echo "$KV_JSON" | jq -r '.name')
  KVID=$(echo "$KV_JSON" | jq -r '.id')

else

  echo "Keyvault Existing : $KV_JSON"
  KVNAME=$(echo "$KV_JSON" | jq -r '.name')
  KVID=$(echo "$KV_JSON" | jq -r '.id')

fi

$echo "Keyvault inside value: $KVNAME  $KVID"

az role assignment create \
 --assignee-object-id $AAD_ADMIN_GROUP_OBJECT_IDS \
 --assignee-principal-type Group \
 --role "Key Vault Secrets Officer" \
 --scope $KVID

az keyvault secret set \
  --vault-name $KVNAME \
  -n $AKSTestSecret \
  --value $AKSTestSecretValue



#NOW GIVE ACCESS TO AKS IDENTITY OBJECTCID
AKSMGNEDID=$(az aks show \
  -g ${RESOURCE_GROUP} \
  -n ${AKS_NAME} \
  --query addonProfiles.azureKeyvaultSecretsProvider.identity.objectId -o tsv)

echo "Managed Id $AKSMGNEDID"

az role assignment create \
 --assignee-object-id $AKSMGNEDID \
 --assignee-principal-type ServicePrincipal \
 --role "Key Vault Secrets User" \
 --scope $KVID