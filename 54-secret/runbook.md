# create a generic secret
kubectl create secret generic super-secret --from-literal=password=bob

secret/super-secret created

# check the created secret
kubectl get secret

NAME           TYPE     DATA   AGE
super-secret   Opaque   1      4s

# create a pod using secret and mount at /secrets

kubectl run pod pod-secrets-via-file --image=redis --dry-run=client -o yaml > pod-01.yml

kubectl explain ..


kubectl apply -f pod-01.yml 
pod/pod created

# check the created pods
kubectl get all
NAME                       READY   STATUS    RESTARTS   AGE
pod/pod-secrets-via-file   1/1     Running   0          5s

NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/kubernetes     ClusterIP   10.132.0.1       <none>        443/TCP   22h
service/nginx-random   ClusterIP   10.132.120.219   <none>        80/TCP    126m

# check the mounted secrets value in pod-secrets-via-file pod
kubectl exec -it pod-secrets-via-file -- sh

cat /secrets/password
bob

# create a pod-secrets-via-env pod which exports password as CONFIDENTIAL
cp pod-01.yml pod-02.yml

kubectl apply -f pod-02.yml 
pod/pod-secrets-via-env created

# check all pods

kubectl get all
NAME                       READY   STATUS    RESTARTS   AGE
pod/pod-secrets-via-env    1/1     Running   0          76s
pod/pod-secrets-via-file   1/1     Running   0          22m

NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/kubernetes     ClusterIP   10.132.0.1       <none>        443/TCP   23h
service/nginx-random   ClusterIP   10.132.120.219   <none>        80/TCP    148m

# check the env value in pod-secrets-via-env pod
kubectl exec -it pod-secrets-via-env -- sh

env
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT=tcp://10.132.0.1:443
CONFIDENTIAL=bob