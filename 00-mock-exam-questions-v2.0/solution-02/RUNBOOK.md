## Setup Configuration 

### Install gatewayclass in your k8s cluster

```bash
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.3.0/standard-install.yaml

customresourcedefinition.apiextensions.k8s.io/gatewayclasses.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/gateways.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/grpcroutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/httproutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/referencegrants.gateway.networking.k8s.io created
```
#### Check the custom resource definitions of gateway api
```bash
kubectl get crds | grep gateway

gatewayclasses.gateway.networking.k8s.io    2025-09-17T05:09:52Z
gateways.gateway.networking.k8s.io          2025-09-17T05:09:52Z
grpcroutes.gateway.networking.k8s.io        2025-09-17T05:09:52Z
httproutes.gateway.networking.k8s.io        2025-09-17T05:09:52Z
referencegrants.gateway.networking.k8s.io   2025-09-17T05:09:52Z
```

### Generate self-signed certificates with scripts

```bash
./cert.sh 
```
EXPECTED OUTPUT:
```bash
ls gw-api/
tls.crt  tls.key
```

#### Create k8s secret for tls key and certificates

```bash
kubectl create secret tls gw-api-tls-secret --cert=gw-api/tls.crt --key=gw-api/tls.key
```
### Install nginx ingress controller with helm

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

```bash
helm install nginx-ingress ingress-nginx/ingress-nginx
```

```bash
helm list -A
NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
nginx-ingress   default         1               2025-09-17 12:31:40.027258443 +0700 +07 deployed        ingress-nginx-4.13.2    1.13.2     
```

### Deploy the app and ingress 

```bash
kubectl apply -f gateway-api-practice.yaml 
deployment.apps/webapp created
service/webapp created
ingress.networking.k8s.io/web created
```
EXPECTED OUTPUT:
```bash
kubectl get all
NAME                          READY   STATUS    RESTARTS   AGE
pod/webapp-69d4ddc945-jgxln   1/1     Running   0          35s

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.133.0.1       <none>        443/TCP   29h
service/webapp       ClusterIP   10.133.242.135   <none>        80/TCP    35s

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/webapp   1/1     1            1           36s

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/webapp-69d4ddc945   1         1         1       35s
```
EXPECTED OUTPUT:
```bash
kubectl get ingress
NAME   CLASS   HOSTS                   ADDRESS          PORTS     AGE
web    nginx   gateway.web.k8s.local   172.18.255.180   80, 443   11m
```
#### Check the ingress is successfully deployed or not
```bash
 curl -k -H "Host: gateway.web.k8s.local" https://172.18.255.180

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```
### Install traefik gateway api with helm

```bash
helm install traefik --namespace=traefik --create-namespace traefik/traefik --set providers.kubernetesGateway.enabled=true
```

### Install `nginx` gatewayclass 

```bash
kubectl apply -f gatewayclass.yaml 
gatewayclass.gateway.networking.k8s.io/nginx created
```
EXPECTED OUTPUT:
```bash
kubectl get gatewayclass
NAME      CONTROLLER                      ACCEPTED   AGE
nginx     traefik.io/gateway-controller   True       6s
traefik   traefik.io/gateway-controller   True       2m51s
```

## Solution Guide

### Create a Gateway named `web-gateway` with hostname gateway.web.k8s.local that maintains the existing TLS

```bash
kubectl apply -f gateway.yaml 
gateway.gateway.networking.k8s.io/web-gateway created
```
EXPECTED OUPUT:
```bash
kubectl get gateway
NAME          CLASS   ADDRESS          PROGRAMMED   AGE
web-gateway   nginx   172.18.255.181   True         10s
```

### Create an HTTPRoute named `web-route` with hostname gateway.web.k8s.local

```bash
kubectl apply -f http-route.yaml 
httproute.gateway.networking.k8s.io/web-route created
```

EXPECTED OUTPUT:
```bash
kubectl get httproute
NAME        HOSTNAMES                   AGE
web-route   ["gateway.web.k8s.local"]   6s
```
EXPECTED OUTPUT(testing with curl):
```bash
curl --insecure --resolve gateway.web.k8s.local:443:172.18.255.181 https://gateway.web.k8s.local 
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
```

### Delete ingress resources

```bash
kubectl delete ingress/web
ingress.networking.k8s.io "web" deleted
```
