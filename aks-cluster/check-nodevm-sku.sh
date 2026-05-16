
source ../scripts/loadenv.sh

echo "listing vm SKUs"

 az aks list-vm-skus \
  --location $LOCATION \
  --all --output table \
  --query "[?contains(name, 'Basic')].size"