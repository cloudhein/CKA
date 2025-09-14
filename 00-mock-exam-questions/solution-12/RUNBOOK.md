## Configure with kustomize 

### Create overlays directory and kustomization file 

├── kustomize
│   ├── base
│   │   ├── deployment.yaml
│   │   └── kustomization.yaml
│   └── overlays
│       └── production
│           └── kustomization.yaml

## Add required config in kustomization file


### ***vim overlays/production/kustomization.yaml***
```bash
resources:
  - ../../base

namePrefix: prod-

labels:
  - pairs:
      environment: production

images:
- name: nginx
  newTag: "1.21"
```
## Deploy the app with kustomization 

```bash
kubectl apply -k kustomize/overlays/production/
deployment.apps/prod-hello-app created
```

```bash
kubectl get all
NAME                                  READY   STATUS    RESTARTS   AGE
pod/prod-hello-app-78d4fb5f9d-2pn5z   1/1     Running   0          32m

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.133.0.1   <none>        443/TCP   30h

NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prod-hello-app   1/1     1            1           32m

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/prod-hello-app-78d4fb5f9d   1         1         1       32m
```

### Check your kusomization labels 
```bash
kubectl get  deployment prod-hello-app -o json | jq -r '.metadata.labels'

{
  "app": "hello",
  "environment": "production"
}
```

### Check your kusomization new image tag
```bash
kubectl get  deployment prod-hello-app -o json | jq -r '.spec.template.spec.containers[0].image'

nginx:1.21
```
