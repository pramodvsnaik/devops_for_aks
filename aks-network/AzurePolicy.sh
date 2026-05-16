source ../scripts/load-env.sh

az aks create \
 -g ${RESOURCE_GROUP} \
 -n ${AKS_NAME} \
 --node-count 2 \
 --network-plugin azure \
 --network-policy azure


az aks get-credentials \
--resource-group ${RESOURCE_GROUP} \
--name ${AKS_NAME}

kubectl create ns demo

kubctl config 

kubectl run client --image nginx
kubectl run server --image nginx

#kubectl node-shell 

10.224.0.49