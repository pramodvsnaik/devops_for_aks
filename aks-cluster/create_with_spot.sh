export SPOT_NODEPOOL="spotnodepool"

# priority=Spot makes the node pool a Spot node pool. 
# Spot node pool ==> handle interruptions like batch processing jobs, dev/test environments, large compute workloads, and more.

az aks nodepool add \
 --resource-group $RESOURCE_GROUP \
 --cluster-name $AKS_CLUSTER \
 --name $SPOT_NODEPOOL \
 --priority Spot \
 --eviction-policy Delete \
 --spot-max-price -1 \
 --enable-cluster-autoscaler \
 --min-count 1 \
 --max-count 2 \
 --no-wait


