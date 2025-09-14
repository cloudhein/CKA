## Setup Guide

### Generate cert & key (self-signed)

```bash
./cert.sh
```
### create ns

```bash
kubectl create ns nginx-static
```
### create tls k8s secret

```bash
kubectl create secret tls nginx-tls-secret --cert=nginx-certs/tls.crt --key=nginx-certs/tls.key -n nginx-static
```
### Create nginx static deployment and configmap setup 

```bash
kubectl apply -f nginx-static-deployment.yaml 

configmap/nginx-config created
deployment.apps/nginx-static created
service/nginx-service created
```

```bash
kubectl get all -n nginx-static
NAME                                READY   STATUS    RESTARTS   AGE
pod/nginx-static-84b9bf855c-jk8s8   1/1     Running   0          15s

NAME                    TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
service/nginx-service   NodePort   10.133.101.162   <none>        443:31337/TCP   15s

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-static   1/1     1            1           15s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-static-84b9bf855c   1         1         1       15s
```

## Update the nginx-config CfgMap to allow only TLSv1.3 

### Delete TLSv1.2 in the configmap of nginx-config
```bash
kubectl edit configmap/nginx-config -n nginx-static

ssl_protocols TLSv1.3;

```

### Do rollout restart after updating the configmap to take effect
```bash
kubectl rollout restart deployment.apps/nginx-static -n nginx-static
deployment.apps/nginx-static restarted
```
