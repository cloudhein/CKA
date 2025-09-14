# create 2 nginx containers with different env values
kubectl run pod nginx-pod --image=nginx --env="env=prod" --dry-run=client -o yaml > nginx-pod-01.yml

kubectl run pod nginx-pod --image=nginx --env="env=dev" --dry-run=client -o yaml > nginx-pod-02.yml

kubectl apply -f nginx-pod-01.yml 
pod/ngninx-pod-01 created

kubectl apply -f nginx-pod-02.yml 
pod/ngninx-pod-02 created

# check the created pods
kubectl get pods -o wide
NAME            READY   STATUS    RESTARTS   AGE   IP           NODE          NOMINATED NODE   READINESS GATES
ngninx-pod-01   1/1     Running   0          64s   10.252.1.3   132-worker3   <none>           <none>
ngninx-pod-02   1/1     Running   0          47s   10.252.3.3   132-worker    <none>           <none>

# check the env vaules in nginx-pod-01
kubectl exec -it ngninx-pod-01 -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=ngninx-pod-01
NGINX_VERSION=1.29.0
NJS_VERSION=0.9.0
NJS_RELEASE=1~bookworm
PKG_RELEASE=1~bookworm
DYNPKG_RELEASE=1~bookworm
env=prod
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.132.0.1
KUBERNETES_SERVICE_HOST=10.132.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.132.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.132.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
TERM=xterm
HOME=/root

# check the env vaules in nginx-pod-02
kubectl exec -it ngninx-pod-02 -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=ngninx-pod-02
NGINX_VERSION=1.29.0
NJS_VERSION=0.9.0
NJS_RELEASE=1~bookworm
PKG_RELEASE=1~bookworm
DYNPKG_RELEASE=1~bookworm
env=dev
KUBERNETES_PORT_443_TCP_ADDR=10.132.0.1
KUBERNETES_SERVICE_HOST=10.132.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.132.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.132.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
TERM=xterm
HOME=/root