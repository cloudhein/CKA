# check all the nodes of k8s cluster
kubectl get nodes --show-labels
NAME                STATUS   ROLES           AGE   VERSION   LABELS
132-control-plane   Ready    control-plane   73s   v1.32.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=132-control-plane,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
132-worker          Ready    <none>          62s   v1.32.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=132-worker,kubernetes.io/os=linux
132-worker2         Ready    <none>          62s   v1.32.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,gpu=nvidia,kubernetes.io/arch=amd64,kubernetes.io/hostname=132-worker2,kubernetes.io/os=linux
132-worker3         Ready    <none>          62s   v1.32.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,gpu=amd,kubernetes.io/arch=amd64,kubernetes.io/hostname=132-worker3,kubernetes.io/os=linux

# create a manifest file for nginx pod
kubectl run pod nginx-kusc00101 --image=nginx --dry-run=client -o yaml > nginx-schedule.yml

# modify and schedule a pod on nvidia nodes  
kubectl apply -f nginx-schedule.yml 
pod/nginx-kusc00101 created

kubectl get pods -o wide
NAME              READY   STATUS    RESTARTS   AGE   IP           NODE          NOMINATED NODE   READINESS GATES
nginx-kusc00101   1/1     Running   0          27s   10.252.3.2   132-worker2   <none>           <none>

# check the node selector
kubectl describe pod nginx-kusc00101
Name:             nginx-kusc00101
Namespace:        default
Priority:         0
Service Account:  default
Node:             132-worker2/172.18.0.4
Start Time:       Sat, 12 Jul 2025 15:11:17 +0700
Labels:           <none>
Annotations:      <none>
Status:           Running
IP:               10.252.3.2
IPs:
  IP:  10.252.3.2
Containers:
  pod:
    Container ID:   containerd://81c311332319f19c0287a41a01b0608dd16a669b46cb993930997cfd2e58fcb5
    Image:          nginx
    Image ID:       docker.io/library/nginx@sha256:93230cd54060f497430c7a120e2347894846a81b6a5dd2110f7362c5423b4abc
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Sat, 12 Jul 2025 15:11:38 +0700
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-s58b4 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  kube-api-access-s58b4:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              gpu=nvidia
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  57s   default-scheduler  Successfully assigned default/nginx-kusc00101 to 132-worker2
  Normal  Pulling    56s   kubelet            Pulling image "nginx"
  Normal  Pulled     36s   kubelet            Successfully pulled image "nginx" in 20.181s (20.181s including waiting). Image size: 72225394 bytes.
  Normal  Created    36s   kubelet            Created container: pod
  Normal  Started    36s   kubelet            Started container pod