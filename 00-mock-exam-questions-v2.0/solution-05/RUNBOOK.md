## Install CNI of your choice

```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml
```

#### EXPCTED OUPUT:
```bash
namespace/kube-flannel created
serviceaccount/flannel created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds created
```

### Make sure to change according to your network setup in your env (These steps may not required and already configured for you in the exam )
```bash
curl -sL https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml | \
sed 's/"Network": "10.244.0.0\/16"/"Network": "10.253.0.0\/16"/' | \
kubectl apply -f -
```

#### EXPCTED OUPUT:
```bash
kubectl get all -n kube-flannel
NAME                        READY   STATUS    RESTARTS   AGE
pod/kube-flannel-ds-bdpvk   1/1     Running   0          28s
pod/kube-flannel-ds-cljvl   1/1     Running   0          28s
pod/kube-flannel-ds-dxcbp   1/1     Running   0          28s
pod/kube-flannel-ds-g5w2g   1/1     Running   0          28s

NAME                             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/kube-flannel-ds   4         4         4       4            4           <none>          28s
```