source ../scripts/loadenv.sh
# source ../scripts/installpkg.sh

# az aks get-credentials \
# --resource-group ${RESOURCE_GROUP} \
# --name ${AKS_NAME}

# kubectl explain deployment --recursive

# kubectl explain deployment --recursive > deployment-full.txt


# kubectl get nodes

# kubectl explain sc --recursive > sc-full.txt
# kubectl apply -f azsc.yaml
kubectl get sc

# kubectl explain pvc --recursive > pvc-full.txt
#  kubectl apply -f azpvc.yaml

# az aks update \
#  --resource-group "$RESOURCE_GROUP" \
#  --name "$AKS_NAME" \
#  --enable-blob-driver