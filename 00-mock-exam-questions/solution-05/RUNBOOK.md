## Create a pod and schedule on node affinity

kubectl apply -f nginx.yaml

```bash
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/hostname
            operator: In
            values:
            - 133-worker
  containers:
  - name: nginx-pod
    image: nginx:latest
```