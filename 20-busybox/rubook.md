# create busybox-pod with sleep 3600 seconds
kubectl run busybox --image=busybox --restart=Never --command -- sleep 3600
pod/busybox created

# list the pods
kubectl get pod
NAME                        READY   STATUS    RESTARTS   AGE
busybox                     1/1     Running   0          36s