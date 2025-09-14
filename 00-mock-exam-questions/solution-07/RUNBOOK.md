## Check your k8s node in your k8s cluster

```bash
kubectl get nodes
NAME                STATUS   ROLES           AGE   VERSION
133-control-plane   Ready    control-plane   8h    v1.33.1
133-worker          Ready    <none>          8h    v1.33.1
133-worker2         Ready    <none>          8h    v1.33.1
133-worker3         Ready    <none>          8h    v1.33.1
```

## Taint the worker-node-01 with NoSchedule Effect

```bash
kubectl taint nodes 133-worker restricted=worker01:NoSchedule
node/133-worker tainted
```

#### Syntax of taint 
```bash
kubectl taint nodes node1 key1=value1:NoSchedule
kubectl taint nodes node1 key1=value1:NoExecute
kubectl taint nodes node1 key2=value2:NoSchedule
``` 

## Deploy the nginx pod on tainted node with tolerations

```bash
kubectl apply -f pod.yaml 
pod/nginx created
```    

## Verify the results

```bash
kubectl get pods -o wide
NAME    READY   STATUS    RESTARTS   AGE   IP            NODE         NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          22s   10.253.3.14   133-worker   <none>           <none>
```