source ./load-env.sh

az aks nodepool list -g $RESOURCE_GROUP --cluster-name $AKS_NAME --query "[].{Name:name, Mode:mode, MaxPod:maxPods}" -o tsv

# export AKV_ID=$(az keyvault create \
#    -g ${RESOURCE_GROUP} \
#    -n ${AKV_NAME} \
#    --enable-rbac-authorization \
#    --query id \
#    --output tsv)