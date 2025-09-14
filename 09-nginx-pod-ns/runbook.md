# create a ns
kubectl create ns engineering
namespace/engineering created

# list the ns
kubectl get ns
NAME                 STATUS   AGE
default              Active   4h11m
engineering          Active   5s

# create nginx yaml file 
kubectl run pod nginx-pod --image=nginx --labels='env=test' --dry-run=client -o yaml > nginx-pod.yml

# modify the nginx yaml file and deploy the nginx pod in engineering ns
kubectl apply -f nginx-pod.yml 
pod/pod created

kubectl get pods -n engineering
NAME   READY   STATUS    RESTARTS   AGE
pod    1/1     Running   0          12s