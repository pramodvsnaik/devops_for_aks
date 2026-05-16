source ../scripts/load-env.sh


#--enable-managed-identity :: Used by AKS Control Plane to interact with Azure; create LB etc
#--enable-workload-identity :: Used by Pods to interact with Azure Service ex KV; using token from OIDC
#--enable-oidc-issuer :: Makes AKS as Token Issuer, tokens generated are validated by EntraID


#--enable-aad :: For AZ Authentication to cluster; Integrates AKS Cluster Authentication with EntraID;
#--aad-admin-group-object-ids :: Assigns Entra Admin Group to AKS Cluster;
#--aad-tenant-id :: Binds AKS Cluster with Tenant
#--enable-azure-rbac :: For AZ RBAC on cluster

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
--enable-oidc-issuer \
--node-vm-size $NODE_VM_SIZE \
--node-count 1 \
--generate-ssh-keys \
--enable-aad \
--enable-azure-rbac \
--aad-admin-group-object-ids $AAD_ADMIN_GROUP_OBJECT_IDS \
--aad-tenant-id $AZURE_TENANT_ID


az aks nodepool add \
 --resource-group ${RESOURCE_GROUP} \
 --cluster-name ${AKS_NAME} \
 --name  ${USER_NODEPOOL} \
 --node-count 1 \
 --mode User


az aks get-credentials \
--resource-group ${RESOURCE_GROUP} \
--name ${AKS_NAME}

