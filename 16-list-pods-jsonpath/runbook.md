# list the pods in jsonpath 
kubectl get pods -o jsonpath="{.items[*]['metadata.name','metadata.namespace']}"

multi-container-pod nginx-kusc00101 webtool-132-control-plane default default default