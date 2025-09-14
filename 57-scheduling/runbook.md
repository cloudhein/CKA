# check all nodes in k8s cluster 
kubectl get nodes

# cordon the node 3 --> mark node as unsheduable
kubectl cordon 132-worker3

# check all nodes after cordon to node 3
kubectl get nodes

NAME                STATUS                     ROLES           AGE   VERSION
132-control-plane   Ready                      control-plane   19h   v1.32.2
132-worker          Ready                      <none>          19h   v1.32.2
132-worker2         Ready                      <none>          19h   v1.32.2
132-worker3         Ready,SchedulingDisabled   <none>          19h   v1.32.2

# drain the node 3
kubectl drain 132-worker3 --delete-emptydir-data=true --ignore-daemonsets --force

node/132-worker3 already cordoned
Warning: ignoring DaemonSet-managed Pods: kube-system/kindnet-72s9j, kube-system/kube-proxy-5nlb7, metallb-system/speaker-b9stw
evicting pod default/reviews-v1-74bd775dc8-9d4k5
evicting pod default/productpage-v1-6b8f8d5445-nkq2w
evicting pod default/productpage-v1-6b8f8d5445-4qzqm
evicting pod default/details-v1-7b998c8fb8-dlst7
pod/details-v1-7b998c8fb8-dlst7 evicted
pod/reviews-v1-74bd775dc8-9d4k5 evicted
pod/productpage-v1-6b8f8d5445-4qzqm evicted
pod/productpage-v1-6b8f8d5445-nkq2w evicted
node/132-worker3 drained

# the pods are automatically scheduled to other nodes 

# check the node status again 
kubectl get nodes

NAME                STATUS                     ROLES           AGE   VERSION
132-control-plane   Ready                      control-plane   19h   v1.32.2
132-worker          Ready                      <none>          19h   v1.32.2
132-worker2         Ready                      <none>          19h   v1.32.2
132-worker3         Ready,SchedulingDisabled   <none>          19h   v1.32.2

kubectl describe node 132-worker3

# after maintenace, uncordon the node 3
kubectl uncordon 132-worker3

node/132-worker3 uncordoned