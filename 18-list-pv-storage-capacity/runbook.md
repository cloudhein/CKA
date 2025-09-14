# list all persistent volumes sorted by capacity
kubectl get pv --sort-by='.metadata.spec.capacity'
