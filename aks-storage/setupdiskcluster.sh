
source ../scripts/loadenv.sh
source ../scripts/installpkg.sh


echo "Creating AKS Cluster: $AKS_NAME"
az aks create \
 --resource-group "$RESOURCE_GROUP" \
 --name "$AKS_NAME" \
 --location "$LOCATION" \
 --tier Free \
 --node-count 1 \
 --generate-ssh-keys \
 --enable-managed-identity \
 --enable-oidc-issuer \
 --node-vm-size Standard_D2d_v4 \
 --service-cidr 172.20.0.0/16 \
 --dns-service-ip '172.20.0.10' \
 --pod-cidr '10.244.0.0/16' \
 --network-plugin azure \
 --network-policy azure \
 --network-plugin-mode overlay




