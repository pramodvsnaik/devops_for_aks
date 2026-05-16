# Set environment variables
export RESOURCE_GROUP=<your-resource-group-name>
export CLUSTER_NAME=<your-aks-cluster-name>

# Create the AKS cluster free/Standard/premium 
az aks create \
 --resource-group $RESOURCE_GROUP \
 --name $CLUSTER_NAME \
 --tier free \
 --generate-ssh-keys