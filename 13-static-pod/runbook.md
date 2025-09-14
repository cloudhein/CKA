# check all nodes labels
kubectl get nodes --show-labels

NAME                STATUS   ROLES           AGE   VERSION   LABELS
132-control-plane   Ready    control-plane   24h   v1.32.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=132-control-plane,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
132-worker          Ready    <none>          24h   v1.32.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=132-worker,kubernetes.io/os=linux
132-worker2         Ready    <none>          24h   v1.32.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=132-worker2,kubernetes.io/os=linux
132-worker3         Ready    <none>          24h   v1.32.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=132-worker3,kubernetes.io/os=linux

# exec into control-plane nodes
docker exec -it 132-control-plane sh

# check kubelet daemon status in control-plane node
systemctl status kubelet

# create web-tools pod with httpd image
cd /etc/kubernets/manifests
touch web-tools.yaml

vim web-tools.yaml

systemctl restart kubelet

# check the systemd web-tools pods
kubectl get pods -o wide

NAME                        READY   STATUS    RESTARTS   AGE     IP            NODE                NOMINATED NODE   READINESS GATES
webtool-132-control-plane   1/1     Running   0          89s     10.252.0.6    132-control-plane   <none>           <none>


kubectl delete pod webtool-132-control-plane

# automatically create systemd pods or restart it if fails 
kubectl get pods -o wide

NAME                        READY   STATUS    RESTARTS   AGE     IP            NODE                NOMINATED NODE   READINESS GATES
webtool-132-control-plane   1/1     Running   0          19s    10.252.0.6    132-control-plane   <none>           <none>