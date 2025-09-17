## Setup Configuration

### Deploy the synergy app first

```bash
kubectl apply -f synergy-deployment-setup.yaml 

namespace/synergy-env created
deployment.apps/synergy-deployment created
```

EXPECTED OUTPUT:
```bash
kubectl get all -n synergy-env

NAME                                     READY   STATUS    RESTARTS   AGE
pod/synergy-deployment-5d68f5c7b-9r72h   1/1     Running   0          24s

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/synergy-deployment   1/1     1            1           24s

NAME                                           DESIRED   CURRENT   READY   AGE
replicaset.apps/synergy-deployment-5d68f5c7b   1         1         1       24s
```

original manifest file
```bash
apiVersion: v1
kind: Namespace
metadata:
  name: synergy-env
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: synergy-deployment
  namespace: synergy-env
spec:
  replicas: 1
  selector:
    matchLabels:
      app: synergy
  template:
    metadata:
      labels:
        app: synergy
    spec:
      containers:
      - name: synergy-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - >
            while true; do
              echo "$(date) - Synergy App is running" >> /var/log/synergy-deployment.log;
              sleep 5;
            done
```

## Solution Setup 

### Add a co-located container named sidecar using the busybox:stable image to the existing Pod and deploy again

```bash
kubectl apply -f synergy-deployment-setup.yaml 

namespace/synergy-env unchanged
deployment.apps/synergy-deployment configured
```

EXPECTED OUTPUT:
```bash
kubectl get all -n synergy-env
NAME                                      READY   STATUS    RESTARTS   AGE
pod/synergy-deployment-59df7897fc-zc4s9   2/2     Running   0          61s

NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/synergy-deployment   1/1     1            1           6m12s

NAME                                            DESIRED   CURRENT   READY   AGE
replicaset.apps/synergy-deployment-59df7897fc   1         1         1       61s
replicaset.apps/synergy-deployment-ccfc66c77    0         0         0       6m12s
```