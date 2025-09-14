## Create  a storage class with policy type 'reclaim'

kubectl apply -f storage-class.yaml 

## Create a pv with specific sc and node affinity configuration

kubectl apply -f persistent-volume.yaml 

### Check your k8s nodes with labels for node affinity config

```bash
kubectl get nodes --show-labels
NAME                STATUS   ROLES           AGE   VERSION   LABELS
133-control-plane   Ready    control-plane   45m   v1.33.1   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=133-control-plane,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
133-worker          Ready    <none>          45m   v1.33.1   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=133-worker,kubernetes.io/os=linux
133-worker2         Ready    <none>          45m   v1.33.1   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=133-worker2,kubernetes.io/os=linux
133-worker3         Ready    <none>          45m   v1.33.1   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=133-worker3,kubernetes.io/os=linux
```

## Create a pvc with specific pv

kubectl apply -f persistent-volume-claim.yaml

### Verify the results

```bash
kubectl get sc
NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
fast-storage         rancher.io/local-path   Retain          Immediate              false                  37m
```

```bash
kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM            STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
my-pv   100Mi      RWO            Retain           Bound    default/my-pvc   fast-storage   <unset>                          14m
```

```bash
kubectl get pvc
NAME     STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
my-pvc   Bound    my-pv    100Mi      RWO            fast-storage   <unset>                 8m36s
```

### Delete the pvc

```bash
kubectl delete pvc my-pvc
persistentvolumeclaim "my-pvc" deleted
```

### Verify the pv is in released state due to retain policy of storage class
```bash
kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM            STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
my-pv   100Mi      RWO            Retain           Released   default/my-pvc   fast-storage   <unset>                          16m
```