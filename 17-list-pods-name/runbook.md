# list all pods sorted by name
kubectl get pods --sort-by='.metadata.name'

NAME                        READY   STATUS    RESTARTS   AGE
multi-container-pod         3/3     Running   0          5h4m
nginx-kusc00101             1/1     Running   0          5h39m
webtool-132-control-plane   1/1     Running   0          3h55m