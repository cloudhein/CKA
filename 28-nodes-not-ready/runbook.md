# list all the nodes in k8s cluster
kubectl get nodes
NAME                STATUS     ROLES           AGE    VERSION
132-control-plane   Ready      control-plane   129m   v1.32.2
132-worker          Ready      <none>          128m   v1.32.2
132-worker2         Ready      <none>          128m   v1.32.2
132-worker3         NotReady   <none>          128m   v1.32.2

# troubleshoot and change the node to ready stage
docker exec -it 132-worker3 sh

systemctl status kubelet
systemctl start kubelet

# list all the nodes in k8s cluster again
kubectl get nodes
NAME                STATUS   ROLES           AGE    VERSION
132-control-plane   Ready    control-plane   131m   v1.32.2
132-worker          Ready    <none>          131m   v1.32.2
132-worker2         Ready    <none>          131m   v1.32.2
132-worker3         Ready    <none>          131m   v1.32.2