## Setup Configuration

### Important Notes of network policy

- By default, if no policies exist in a namespace, then all ingress and egress traffic is allowed to and from pods in that namespace.
- Only if we want to explicitly enforce network policy, it must be enforced to specific pod using labels.
- Standard Network policy in k8s cluster is like security group from AWS (can knowledge transfer and same technology patterns)
- So, if traffic is allowed in ingress, return traffic is automatically allowed. (stateful fw SG concept of AWS)
- If we want to enforce network policy, we must use only CNI that support network policy.

### Deploy neccessary setup for this usecases

```bash
kubectl apply -f netpol-practice-setup.yaml 

namespace/frontend created
namespace/backend created
networkpolicy.networking.k8s.io/deny-all created
networkpolicy.networking.k8s.io/deny-all created
deployment.apps/backend created
deployment.apps/frontend created
```

```bash
kubectl apply -f netpool-svc.yaml 
service/frontend-svc created
service/backend-svc created
```

```bash
kubectl apply -f netpool-frontend-egress.yaml 
networkpolicy.networking.k8s.io/allow-dns created
networkpolicy.networking.k8s.io/allow-frontend-egress-to-backend created
```

## Solution Setup

### Choose the network policy with least privileges for this usecases

```bash
kubectl apply -f netpol-2.yaml 
networkpolicy.networking.k8s.io/allow-frontend-to-backend created
```

EXPECTED OUTPUT:
```bash
kubectl get networkpolicies -A

NAMESPACE   NAME                        POD-SELECTOR   AGE
backend     allow-frontend-to-backend   app=backend    19s
backend     deny-all                    <none>         22m
frontend    deny-all                    <none>         22m
```

EXPECTED OUTPUT for testing:
```bash
kubectl exec -it pod/frontend-684ff45d4f-4kwqf -n frontend -- sh

# curl http://backend-svc.backend.svc.cluster.local
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```