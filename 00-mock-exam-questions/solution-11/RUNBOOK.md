# Setup Guide

## Pull the traekfik repo with helm chart

```bash
helm repo add --force-update traefik https://traefik.github.io/charts

helm repo update
```

# Solution

## List and output the values of traefik gateway api to check the value of gateway api

```bash
helm show values traefik/traefik > values.yaml
```

## Install it in a dedicated namespace traefik with release name traefik and enable gateway api

```bash
helm install traefik traefik/traefik -n traefik --create-namespace --set providers.kubernetesGateway.enabled=true
```
EXPECTED OUTPUT:
```bash
helm list -A
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
traefik traefik         1               2025-09-13 15:06:13.806343578 +0700 +07 deployed        traefik-37.1.1  v3.5.2 
```

EXPECTED OUTPUT:
```bash
kubectl get all -n traefik
NAME                          READY   STATUS    RESTARTS   AGE
pod/traefik-c84d5f764-2vd9f   1/1     Running   0          3m6s

NAME              TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)                      AGE
service/traefik   LoadBalancer   10.133.226.230   172.18.255.180   80:30185/TCP,443:31451/TCP   11m

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/traefik   1/1     1            1           11m

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/traefik-7cf7bc96dd   0         0         0       11m
replicaset.apps/traefik-c84d5f764    1         1         1       3m6s
```
