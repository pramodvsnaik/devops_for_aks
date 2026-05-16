
source ./load-env.sh

# az aks create \
# --resource-group ${RESOURCE_GROUP} \
# --name ${AKS_NAME} \
# --location ${LOCATION} \
# --network-plugin azure \
# --network-plugin-mode overlay \
# --network-dataplane cilium \
# --network-policy cilium \
# --enable-managed-identity \
# --enable-workload-identity \
# --enable-oidc-issuer \
# --node-vm-size $NODE_VM_SIZE \
# --node-count 1 \
# --generate-ssh-keys

az aks nodepool add \
 --resource-group ${RESOURCE_GROUP} \
 --cluster-name ${AKS_NAME} \
 --name  ${USER_NODEPOOL} \
 --node-count 1 \
 --mode User

az aks get-credentials \
--resource-group ${RESOURCE_GROUP} \
--name ${AKS_NAME}

