# list of all the pods showing name and namespace with a jsonpath expression
kubectl get pods -o jsonpath="{.items[*]['.metadata.name','.metadata.namespace']}"
kucc8 default