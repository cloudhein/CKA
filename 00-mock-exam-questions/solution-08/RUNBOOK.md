## Create statefulset of nginx pod 

```bash
kubectl apply -f nginx-statefulset.yaml 
service/web created
statefulset.apps/web created
```

## Verify the results

```bash
kubectl get all
NAME        READY   STATUS    RESTARTS   AGE
pod/web-0   1/1     Running   0          44s
pod/web-1   1/1     Running   0          48s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.133.0.1   <none>        443/TCP   10h
service/web          ClusterIP   None         <none>        80/TCP    2m24s

NAME                   READY   AGE
statefulset.apps/web   2/2     2m24s
```

#### pvc is created by volumeclaim templates of statefulset and namespaced bound
```bash
kubectl get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
storage-web-0   Bound    pvc-6c7ae88e-e704-4ad6-a522-b620be84c0de   1Gi        RWO            standard       <unset>                 18m
storage-web-1   Bound    pvc-c71d05aa-90aa-487d-8ff5-8d84d7ceab3a   1Gi        RWO            standard       <unset>                 18m
```

#### pv is created from pvc and it is dynamically created 
```bash
kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-6c7ae88e-e704-4ad6-a522-b620be84c0de   1Gi        RWO            Delete           Bound    default/storage-web-0   standard       <unset>                          18m
pvc-c71d05aa-90aa-487d-8ff5-8d84d7ceab3a   1Gi        RWO            Delete           Bound    default/storage-web-1   standard       <unset>                          18m
```