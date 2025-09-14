# Scale the deployment webserver to 3 pods
kubectl scale --replicas=3 deployment.apps/productpage-v1
deployment.apps/productpage-v1 scaled
