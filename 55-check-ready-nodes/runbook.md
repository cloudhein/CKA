# Check the ready nodes only (not including nodes tainted NoSchedule)
kubectl get nodes  | awk '$2 == "Ready" {print $1}' | while read node; do kubectl get node "$node" -o json | grep -q NoSchedule || echo "$node"; done | wc -l > /tmp/KUNW00601/test2.txt


kubectl get nodes | awk '$2=="Ready"'

132-control-plane   Ready                      control-plane   21h   v1.32.2
132-worker          Ready                      <none>          21h   v1.32.2
132-worker2         Ready                      <none>          21h   v1.32.2

kubectl get nodes | awk '$2=="Ready" {print $1}' 

132-control-plane
132-worker
132-worker2

kubectl get nodes | awk '$2=="Ready" {print $1}' | wc -l

3

# store the total numbers of ready nodes into the files
kubectl get nodes | awk '$2=="Ready" {print $1}' | wc -l > /tmp/KUNW00601/test.txt

cat /tmp/KUNW00601/test.txt
3

# check all the nodes in k8s cluster 
kubectl get nodes

NAME                STATUS                     ROLES           AGE   VERSION
132-control-plane   Ready                      control-plane   21h   v1.32.2
132-worker          Ready                      <none>          21h   v1.32.2
132-worker2         Ready                      <none>          21h   v1.32.2
132-worker3         Ready,SchedulingDisabled   <none>          21h   v1.32.2
