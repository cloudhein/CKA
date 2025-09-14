# create a nginx deployment 
kubectl create deployment nginx-random --image=nginx 

deployment.apps/nginx-random created

# check the deployment status
kubectl get all

NAME                                READY   STATUS    RESTARTS   AGE
pod/nginx-random-7b49799c4c-tsb2q   1/1     Running   0          113s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.132.0.1   <none>        443/TCP   20h

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-random   1/1     1            1           114s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-random-7b49799c4c   1         1         1       114s


# expose via nginx-random service 
kubectl expose deployment nginx-random --name=nginx-random --port=80 --target-port=80

service/nginx-random exposed

# check the deployment status
kubectl get all

NAME                                READY   STATUS    RESTARTS   AGE
pod/nginx-random-7b49799c4c-tsb2q   1/1     Running   0          5m25s

NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/kubernetes     ClusterIP   10.132.0.1       <none>        443/TCP   20h
service/nginx-random   ClusterIP   10.132.120.219   <none>        80/TCP    3s

NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-random   1/1     1            1           5m25s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-random-7b49799c4c   1         1         1       5m25s

# Port-forward the nginx-random service 
kubectl port-forward service/nginx-random --address 0.0.0.0 :80

Forwarding from 0.0.0.0:38379 -> 80

# create a busybox pod to test service discovery 
kubectl run busybox --image=busybox --command sleep 3600 
pod/busybox created

# check the service dns record for service discovery

kubectl exec -it pod/busybox -- sh

nslookup nginx-random.default.svc.cluster.local
Server:         10.132.0.10
Address:        10.132.0.10:53


Name:   nginx-random.default.svc.cluster.local
Address: 10.132.120.219

# check the pod dns record 

kubectl exec -it pod/busybox -- sh

nslookup 10.252.2.8

Server:         10.132.0.10
Address:        10.132.0.10:53

8.2.252.10.in-addr.arpa name = 10-252-2-8.nginx-random.default.svc.cluster.local


nslookup 10-252-2-8.nginx-random.default.svc.cluster.local
Server:         10.132.0.10
Address:        10.132.0.10:53


Name:   10-252-2-8.nginx-random.default.svc.cluster.local
Address: 10.252.2.8

<pod-ip>.<svc-name>.<ns-name>.svc.<cluster-domain>

# store the dns records in the respective files

kubectl exec -it pod/busybox -- nslookup nginx-random.default.svc.cluster.local > /tmp/KUNW00601/service.dns

kubectl exec -it pod/busybox -- nslookup 10-252-2-8.nginx-random.default.svc.cluster.local > /tmp/KUNW00601/pod.dns
