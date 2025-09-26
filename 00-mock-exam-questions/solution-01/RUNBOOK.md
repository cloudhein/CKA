# SetUp Guide

```bash
kubectl apply -f sc.yaml 
storageclass.storage.k8s.io/local-path created
```
EXPECTED OUTPUT:
```bash
kubectl get sc
NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path           rancher.io/local-path   Delete          WaitForFirstConsumer   false                  3s
standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  10h
````

# Solution

## Create a persistent volume claim

 kubectl apply -f persistent-volumeclaim.yaml 

```bash
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Mi
  storageClassName: local-path
```

## Create a pod that uses the PVC

 kubectl apply -f pod-01.yaml 

```bash
apiVersion: v1
kind: Pod
metadata:
  name: pod-01
spec:
  volumes:
  - name: my-pv
    persistentVolumeClaim:
      claimName: my-pvc
  containers:
  - name: pod-01
    image: busybox
    command: ['sh', '-c', 'echo "Hello, Kubernetes!" && sleep 3600']
    volumeMounts:
    - name: my-pv
      mountPath: /data
```

### Verify the results

```bash
kubectl get pvc
NAME     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
my-pvc   Bound    pvc-4c55339e-2871-4fda-b4e4-43e214a5971e   100Mi      RWO            standard       <unset>                 10m
```

```bash
kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM            STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-4c55339e-2871-4fda-b4e4-43e214a5971e   100Mi      RWO            Delete           Bound    default/my-pvc   standard       <unset>                          6m8s
```

```bash
kubectl get pods
NAME     READY   STATUS    RESTARTS   AGE
pod-01   1/1     Running   0          5m16s
```

```bash
kubectl exec -it pod-01 -- sh
/ # ls /data -lshd
   4.0K drwxrwxrwx    2 root     root        4.0K Sep 12 03:53 /data
```

