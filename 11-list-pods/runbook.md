# list the pods in json format
kubectl get pods nginx-kusc00101 -o json

# list the pod with custom columns POD_NAME and POD_STATUS
kubectl get pod nginx-kusc00101 -o custom-columns='POD_NAME:.metadata.name,POD_STATUS:.status.containerStatuses[0].state
'
POD_NAME          POD_STATUS
nginx-kusc00101   map[running:map[startedAt:2025-07-12T09:13:35Z]]