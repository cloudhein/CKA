# generate manifest files for multi-containers-pods
kubectl run pod --image=nginx --dry-run=client -o yaml > muti-containers-pods.yml

# modify and create multi-containers-pod with nginx + redis + memcached + consul
kubectl apply -f muti-containers-pods.yml 
pod/kucc8 created


kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
details-v1-7b998c8fb8-5tdnw       1/1     Running   0          100m
kucc8                             4/4     Running   0          95s

# port-forward the consul container in the pod/kucc8
kubectl port-forward pod/kucc8 :8500
Forwarding from 127.0.0.1:46715 -> 8500
Forwarding from [::1]:46715 -> 8500
Handling connection for 46715