## Create a persistent volume 

kubectl apply -f persistent-volume.yaml

### Verify the pv is created

```bash 
kubectl get pv
NAME                CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                        STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
static-pv-example   200Mi      RWO            Retain           Bound    default/static-pvc-example   standard       <unset>                          3m20s
```

## Create a persistent volume claim

kubectl apply -f persistent-volume-claim.yaml

### Verify the pvc is created and bound to pv

```bash
kubectl get pvc
NAME                 STATUS   VOLUME              CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
static-pvc-example   Bound    static-pv-example   200Mi      RWO            standard       <unset>                 111s
```

