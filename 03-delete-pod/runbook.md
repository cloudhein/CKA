# delete pods

kubect1 get pods -o wide
kubectl delete po “nginx-dev”kubectl delete po “nginx-prod”