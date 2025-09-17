## Add the official Argo CD Helm repository with the name argo

```bash
helm repo add argo https://argoproj.github.io/argo-helm
```

### Check the argo repo 

```bash
helm search repo argo
NAME                            CHART VERSION   APP VERSION     DESCRIPTION                                       
argo/argo                       1.0.0           v2.12.5         A Helm chart for Argo Workflows                   
argo/argo-cd                    8.3.7           v3.1.5          A Helm chart for Argo CD, a declarative, GitOps...
argo/argo-ci                    1.0.0           v1.0.0-alpha2   A Helm chart for Argo-CI                          
argo/argo-events                2.4.16          v1.9.7          A Helm chart for Argo Events, the event-driven ...
argo/argo-lite                  0.1.0                           Lighweight workflow engine for Kubernetes         
argo/argo-rollouts              2.40.4          v1.8.3          A Helm chart for Argo Rollouts                    
argo/argo-workflows             0.45.24         v3.7.2          A Helm chart for Argo Workflows                   
argo/argocd-applicationset      1.12.1          v0.4.1          A Helm chart for installing ArgoCD ApplicationSet 
argo/argocd-apps                2.0.2                           A Helm chart for managing additional Argo CD Ap...
argo/argocd-image-updater       0.12.3          v0.16.0         A Helm chart for Argo CD Image Updater, a tool ...
argo/argocd-notifications       1.8.1           v1.2.1          A Helm chart for ArgoCD notifications, an add-o...
bitnami/argo-cd                 11.0.0          3.1.1           Argo CD is a continuous delivery tool for Kuber...
bitnami/argo-workflows          13.0.6          3.7.1           Argo Workflows is meant to orchestrate Kubernet...
```

## Create a namspace for argocd

```bash
kubectl create ns argocd
```

## Generate a helm template of the Argo CD Helm chart without installing CRDs

```bash
helm template argocd argo/argo-cd --version 7.7.3 --namespace argocd --set crds.install=false > ./argo-helm.yaml
```

## Install argocd in argocd namespace and configure it to not install CRDs

```bash
kubectl apply -f argo-helm.yaml
```

