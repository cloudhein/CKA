# create pod with env variables
kubectl run pod --image=nginx --env="var1=value1" --dry-run=client -o yaml > pod.yml

kubectl apply -f pod.yml

# check the nginx-pod

kubectl get pods -o wide
NAME        READY   STATUS    RESTARTS   AGE   IP           NODE          NOMINATED NODE   READINESS GATES
nginx-pod   1/1     Running   0          22s   10.252.2.2   132-worker2   <none>           <none>

# check the env varibles 
kubectl exec -it nginx-pod -- sh

env
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT=tcp://10.132.0.1:443
HOSTNAME=nginx-pod
var1=value1
HOME=/root
PKG_RELEASE=1~bookworm
DYNPKG_RELEASE=1~bookworm
TERM=xterm
NGINX_VERSION=1.29.0
KUBERNETES_PORT_443_TCP_ADDR=10.132.0.1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
NJS_VERSION=0.9.0
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
NJS_RELEASE=1~bookworm
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT_443_TCP=tcp://10.132.0.1:443
KUBERNETES_SERVICE_HOST=10.132.0.1