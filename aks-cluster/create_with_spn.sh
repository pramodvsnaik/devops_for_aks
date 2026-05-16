#Create SPN

# SPN_CRED=$(az ad sp create-for-rbac \
#  --skip-assignment \
#  --name spn-aks-dva \
#  --query "{Id:appId, Secret:password}" \
#  -o json )

source ../scripts/load-env.sh

# az aks create \
#  -g ${RESOURCE_GROUP} \
#  -n ${AKS_NAME} \
#  --node-count 1 \
#  --service-principal ${SPN_ID} \
#  --client-secret ${SPN_SEC}


# az aks get-credentials \
# --resource-group ${RESOURCE_GROUP} \
# --name ${AKS_NAME}

# curl -LO https://github.com/kvaps/kubectl-node-shell/raw/master/kubectl-node_shell
# chmod +x ./kubectl-node_shell
# sudo mv ./kubectl-node_shell /usr/local/bin/kubectl-node_shell

az aks update-credentials \
 --resource-group ${RESOURCE_GROUP} \
 --name ${AKS_NAME} \
 --reset-service-principal \
 --service-principal "$SPN_ID" \
 --client-secret "${SPN_SEC}"