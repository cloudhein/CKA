## Solution

### Check the existing storage class (default sc) in your k8s cluster

```bash
kubectl get sc
NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  91m
```

### Create a new StorageClass named `low-latency` and set as `default StorageClass`

```bash
kubectl get sc standard -o yaml > low-latency-sc.yaml
```

low-latency-sc.yaml
```bash
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  name: low-latency
provisioner: rancher.io/local-path
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
```

```bash
kubectl apply -f low-latency-sc.yaml
```

#### Reconfigure the storage class `standard` and remove from `default stoage class`

```bash
kubectl edit sc standard 
storageclass.storage.k8s.io/standard edited

## Change according to this configuration
Change the default-class to `false`
storageclass.kubernetes.io/is-default-class: "false"
```

EXPECTED OUTPUT:
```bash
kubectl get sc
NAME                    PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
low-latency (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  8m36s
standard                rancher.io/local-path   Delete          WaitForFirstConsumer   false                  102m              94m
```