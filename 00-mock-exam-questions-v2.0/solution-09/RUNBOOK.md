## Setup Configuration 

### Deploy application in sp-culator namespace

```bash
kubectl apply -f sp-culator-setup.yaml 

namespace/sp-culator created
deployment.apps/front-end created
```

## Solution Steps

### Check the deployed app in sp-culator namespace

```bash
kubectl get all -n sp-culator

NAME                             READY   STATUS    RESTARTS   AGE
pod/front-end-64cf566b77-7k9nz   1/1     Running   0          56s
pod/front-end-64cf566b77-v7znv   1/1     Running   0          56s

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/front-end   2/2     2            2           56s

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/front-end-64cf566b77   2         2         2       56s
```

### Reconfigure the existing Deployment to expose port 80/tcp of the existing container nginx

```bash
kubectl edit deployment.apps/front-end -n sp-culator

## Add this following config in existing deployment 
 ports:
          - containerPort: 80
            protocol: TCP
```

### Create a new Service named `front-end-svc` exposing the container port 80/tcp

```bash
kubectl expose deployment front-end --port=80 --name=front-end-svc -n sp-culator
service/front-end exposed
```

EXPECTED OUTPUT:
```bash
kubectl get svc -n sp-culator
NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
front-end-svc   ClusterIP   10.133.157.133   <none>        80/TCP    22s
```

### Configure the new Service to also expose the individual pods via & NodePort

```bash
kubectl edit svc -n sp-culator
service/front-end-svc edited

Change the service type from `ClusterIP` to `NodePort`
type: NodePort
```

EXPECTED OUTPUT:
```bash
kubectl get svc -n sp-culator
NAME            TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
front-end-svc   NodePort   10.133.157.133   <none>        80:32207/TCP   5m31s
```