sudo apt-get update

az || curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

kubectl || sudo apt-get install -y kubectl

az aks || az extension add --name aks-preview
az aks || az extension add -n k8s-extension

 az login \
 --service-principal \
 -u "$AZURE_APP_ID" \
 -p "$AZURE_SECRET" \
 -t "$AZURE_TENANT_ID" -o none

az account set --subscription "$AZURE_SUBSCRIPTION_ID"



