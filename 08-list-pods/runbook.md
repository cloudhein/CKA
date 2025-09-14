# check the specific pods with json output
kubectl get pod details-v1-7b998c8fb8-9pzbz -o json

# check the pods sorted by created timestamp

kubectl get pods --sort-by='.metadata.creationTimestamp'
NAME                              READY   STATUS    RESTARTS   AGE
details-v1-7b998c8fb8-9pzbz       1/1     Running   0          31m
productpage-v1-6b8f8d5445-2tjvx   1/1     Running   0          31m
ratings-v1-c7ffd66bd-7vz77        1/1     Running   0          31m
reviews-v1-74bd775dc8-r5l4x       1/1     Running   0          31m
reviews-v2-5955d8df7-mmzxd        1/1     Running   0          31m
reviews-v3-7d87f694fd-spdxp       1/1     Running   0          31m