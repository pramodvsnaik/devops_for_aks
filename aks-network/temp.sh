# kubectl create networkpolicy allow-nginx \
#  --namespace demo \
#  --dry-run=client \
#  -o yaml

 kubectl create networkpolicy allow-nginx \
  --dry-run=client -o yaml


$k apply -f netpol.yaml
networkpolicy.networking.k8s.io/access-nginx configured
$k exec -it client -- bash
root@client:/# curl --connect-timeout 5 10.224.0.49
curl: (28) Connection timed out after 5002 milliseconds