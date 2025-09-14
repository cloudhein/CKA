## Setup Configuration

### Create a new namespace and Deploy the echo app 

```bash
kubectl apply -f echo-ingress-setup.yaml 

namespace/echo-sound created
deployment.apps/echoserver created
service/echoserver-service created
```

Expected result:
```bash
kubectl get all -n echo-sound

NAME                             READY   STATUS    RESTARTS   AGE
pod/echoserver-749dfd9ff-gzbck   1/1     Running   0          40s

NAME                         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/echoserver-service   ClusterIP   10.133.224.132   <none>        8080/TCP   40s

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/echoserver   1/1     1            1           40s

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/echoserver-749dfd9ff   1         1         1       40s
```

### Ingress controller must be installed in order for ingress to work successfully

#### Add nginx ingress helm repo
```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update
```

#### Install ingress nginx with helm chart
```bash
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
```

Expected output:
```bash
kubectl get all -n ingress-nginx

NAME                                            READY   STATUS    RESTARTS   AGE
pod/ingress-nginx-controller-6b96cf684f-5b64s   1/1     Running   0          5m49s

NAME                                         TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)                      AGE
service/ingress-nginx-controller             LoadBalancer   10.133.61.231    172.18.255.181   80:30114/TCP,443:30413/TCP   5m49s
service/ingress-nginx-controller-admission   ClusterIP      10.133.252.102   <none>           443/TCP                      5m49s

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ingress-nginx-controller   1/1     1            1           5m49s

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/ingress-nginx-controller-6b96cf684f   1         1         1       5m49s
```

#### Check the ingress class of ingress controller in your k8s cluster 
```bash
 kubectl get ingressclass
NAME      CONTROLLER                      PARAMETERS   AGE
nginx     k8s.io/ingress-nginx            <none>       16m
traefik   traefik.io/ingress-controller   <none>       7h43m
```

## Solution

### Install ingress 
```bash
kubectl apply -f ingress.yaml 
ingress.networking.k8s.io/echo created
```

Expected output:
```bash
kubectl get ingress -n echo-sound
NAME   CLASS   HOSTS         ADDRESS          PORTS   AGE
echo   nginx   example.org   172.18.255.181   80      86s
```

```bash
curl -H "Host: example.org" http://172.18.255.181/echo
```