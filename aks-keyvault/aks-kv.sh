
source ./load-env.sh

az aks create \
--resource-group ${RESOURCE_GROUP} \
--name ${AKS_NAME} \
--location ${LOCATION} \
--network-plugin azure \
--network-plugin-mode overlay \
--network-dataplane cilium \
--network-policy cilium \
--enable-managed-identity \
--enable-workload-identity \
--enable-addons azure-keyvault-secrets-provider \
--enable-oidc-issuer \
--node-vm-size $NODE_VM_SIZE \
--node-count 1 \
--generate-ssh-keys

az aks nodepool add \
 --resource-group ${RESOURCE_GROUP} \
 --cluster-name ${AKS_NAME} \
 --name  ${USER_NODEPOOL} \
 --node-count 1 \
 --mode User

az aks get-credentials \
--resource-group ${RESOURCE_GROUP} \
--name ${AKS_NAME}

az keyvault create \
--name $AKV_NAME \
-g ${RESOURCE_GROUP} \
-l ${LOCATION} \
--enable-rbac-authorization

KVID=$(az keyvault show \
       -n $AKV_NAME \
       -g $RESOURCE_GROUP \
       --query id -o tsv )

MYID=$(az ad signed-in-user show --query id -o tsv)

az role assignment create \
 --assignee-object-id $MYID \
 --role "b86a8fe4-44ce-4948-aee5-eccb2c155cd7" \
 --scope $KVID \
 --assignee-principal-type User

 AKSCLUSTEROBID=$(az aks show \
       -n $AKS_NAME \
       -g $RESOURCE_GROUP \
       --query addonProfiles.azureKeyvaultSecretsProvider.identity.objectId -o tsv )

AKSCLUSTERCLID=$(az aks show \
       -n $AKS_NAME \
       -g $RESOURCE_GROUP \
       --query addonProfiles.azureKeyvaultSecretsProvider.identity.clientId -o tsv )

echo $AKSCLUSTERID

az role assignment create --role "Key Vault Certificate User" --assignee $AKSCLUSTEROBID --scope $KVID
