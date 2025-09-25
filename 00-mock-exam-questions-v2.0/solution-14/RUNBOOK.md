## Setup Configuration

### Create mariadb namespace

kubectl create ns mariadb

### Create PersistentVolume (PV) 

```bash
kubectl apply -f mariadb-pv.yaml 
persistentvolume/mariadb-pv created
```

EXPECTED OUTPUT:
```bash
kubectl get pv
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
mariadb-pv   250Mi      RWO            Retain           Available                          <unset>                          4s
```

### Create mariadb deployment 

mariadb-deployment.yaml
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
        - name: mariadb
          image: mariadb:10.6
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: "password"
          ports:
            - containerPort: 3306
          volumeMounts:
            - name: mariadb-storage
              mountPath: /var/lib/mysql
      volumes:
        - name: mariadb-storage
          emptyDir: {}    # ⚠️ This is where you’ll replace with PVC
```

#### Deploy maridb application 
```bash
kubectl apply -f mariadb-deployment.yaml 
namespace/mariadb created
deployment.apps/mariadb created
```

## Solution Steps

### Create persistent volume claims

```bash
kubectl apply -f mariadb-pvc.yaml 
persistentvolumeclaim/mariadb created
```
EXPECTED OUTPUT:

```bash
kubectl get pvc -n mariadb
NAME      STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
mariadb   Bound    mariadb-pv   250Mi      RWO                           <unset>                 52s
```

```bash
kubectl get pv
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
mariadb-pv   250Mi      RWO            Retain           Bound    mariadb/mariadb                  <unset>                          21m
```

### Reconfigure the mariadb deployment and use PVC created in the previous step

```bash
kubectl apply -f mariadb-pvc-deployment.yaml
deployment.apps/mariadb configured
```

EXPECTED OUTPUT:
```bash
kubectl get all -n mariadb

NAME                          READY   STATUS    RESTARTS   AGE
pod/mariadb-94c7b9d79-wl64f   1/1     Running   0          26s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mariadb   1/1     1            1           9m40s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/mariadb-75b7f5df74   0         0         0       9m40s
replicaset.apps/mariadb-94c7b9d79    1         1         1       26s
```

### Data is persistent even if we delete mariadb deployment 

```bash
kubectl delete -f mariadb-pvc-deployment.yaml
deployment.apps "mariadb" deleted
```
EXPECTED OUTPUT:

```bash
kubectl get pvc -n mariadb
NAME      STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
mariadb   Bound    mariadb-pv   250Mi      RWO                           <unset>                 5m20s
```
```bash
kubectl get pv
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
mariadb-pv   250Mi      RWO            Retain           Bound    mariadb/mariadb                  <unset>                          25m
```
