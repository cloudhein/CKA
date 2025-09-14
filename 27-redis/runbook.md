# create a staging ns
kubectl create ns staging
namespace/staging created

# generate a manifest file for redis pod
kubectl run pod --image=redis --dry-run=client -o yaml > redis.yaml

# modify and deploy a non-persistent redis pod in staging ns
kubectl apply -f redis.yaml 
pod/non-persistent-redis created

kubectl get pods -n staging
NAME                   READY   STATUS    RESTARTS   AGE
non-persistent-redis   1/1     Running   0          7s