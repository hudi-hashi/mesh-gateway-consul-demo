
### Deploy the clusters

terraform apply -auto-approve

### Configure kubernetes contexts
aws eks update-kubeconfig --region us-east-2 --name nwales_eks_primary --alias primary
aws eks update-kubeconfig --region us-west-2 --name nwales_eks_secondary --alias secondary


### Setup the primary datacenter

kubectl config use-context primary
helm install consul hashicorp/consul --create-namespace --namespace consul --values helm/primary/config.yaml


### Get the federation secret from the primary cluster

kubectl get secret consul-federation --namespace consul --output yaml > consul-federation-secret.yaml

### Create Consul namespace on the secondary cluster

kubectl config use-context secondary
kubectl create namespace consul

### Write federation secrets to the secondary cluster 

kubectl apply -f consul-federation-secret.yaml --namespace consul

### Update the secondary helm chart k8sAuthMethodHost value with the API address for the secondary cluster

e.g. 

```
  federation:
    enabled: true
    k8sAuthMethodHost: https://<uid>.sk1.us-west-2.eks.amazonaws.com
    ...
```

### Install the secondary cluster

helm install consul hashicorp/consul --namespace consul --values helm/secondary/config.yaml


### Configure mesh gateways for service mesh traffic

kubectl apply -f apps/config/proxy/mesh-gateway-defaults.yaml


### Deploy apps

kubectl apply -f apps/counting-api.yaml

kubectl config use-context primary
kubectl apply -f apps/counting-api.yaml
kubectl apply -f apps/dashboard.yaml

### Watch the dashboard
kubectl port-forward deploy/dashboard 9002:9002

### Enable failover for the counting app
kubectl apply -f apps/config/enable-counting-failover.yaml

### Set the





Sourced from: https://www.consul.io/docs/k8s/installation/multi-cluster/kubernetes