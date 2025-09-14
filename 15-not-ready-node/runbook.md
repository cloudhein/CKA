# check all the nodes
kubectl get nodes

# start the kubelet dameon in one of node (if not ready)
systemctl start kubelet

systemctl restart kubelet

# check all the nodes again
kubectl get nodes
NAME                STATUS   ROLES           AGE     VERSION
132-control-plane   Ready    control-plane   6h33m   v1.32.2
132-worker          Ready    <none>          6h33m   v1.32.2
132-worker2         Ready    <none>          6h33m   v1.32.2
132-worker3         Ready    <none>          6h33m   v1.32.2