# Questions

1. Add an init container to hungry-bear (which has been defined in spec file
/opt/KUCC00108/pod-spec-KUCC00108.yaml)
2. The init container should create an empty file named/workdir/calm.txt
3. If /workdir/calm.txt is not detected, the pod should exit
4. Once the spec file has been updated with the init container definition, the pod should be created

# Solutions
kubectl apply -f init-container.yml 
pod/hungry-bear created

# list the pods (you will see init container run before app containers)
kubectl get pods
NAME          READY   STATUS            RESTARTS   AGE
hungry-bear   0/1     PodInitializing   0          4s

# list the pods
kubectl get pods
NAME          READY   STATUS    RESTARTS   AGE
hungry-bear   1/1     Running   0          13s

# exec into pod and check the crated files
kubectl exec -it hungry-bear -- sh
Defaulted container "hungry-bear-container" out of: hungry-bear-container, calm-init (init)

/ # ls /workdir/calm.txt
/workdir/calm.txt
/ # cat /workdir/calm.txt

# Notes (Init Containers)
- specialized containers that run before app containers in a Pod. 
- Init containers can contain utilities or setup scripts not present in an app image.
- run before the app container to do certain task
- kubelet repeatedly restarts that init container until it succeeds.

[init-container-doc](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

# Notes (SideCar Containers)
- run all the time with the app containers
- secondary containers that run along with the main application container within the same Pod
- can specify a restartPolicy for containers listed in a Pod's initContainers field.
- These restartable sidecar containers are independent from other init containers and from the main application container(s) within the same pod.
- These can be started, stopped, or restarted without affecting the main application container and other init containers.