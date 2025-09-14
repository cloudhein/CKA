## Setup Configuration

**⚠️ Important**: Metrics server must be installed first as HPA cannot function without it.

### 1. Add Helm Repository

```bash
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
```

### 2. Install Metrics Server

```bash
helm install metrics-server metrics-server/metrics-server \
  --namespace kube-system \
  --set args[0]="--kubelet-insecure-tls"
```

### 3. Verify Installation

```bash
kubectl get all -n kube-system -l app.kubernetes.io/name=metrics-server
```

Expected output:
```bash
NAME                                  READY   STATUS    RESTARTS   AGE
pod/metrics-server-5dd7b49d79-v29xq   1/1     Running   0          24s

NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/metrics-server   ClusterIP   10.133.31.172   <none>        443/TCP   24s

NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/metrics-server   1/1     1            1           24s

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/metrics-server-5dd7b49d79   1         1         1       24s
```
### 4. Test Metrics Collection

Verify that metrics collection is working:

```bash
# Check pod resource usage
kubectl top pods -n kube-system

# Check node resource usage
kubectl top node
```

Sample output:
```bash
NAME                CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)   
133-control-plane   171m         1%       1320Mi          5%          
133-worker          31m          0%       380Mi           1%          
133-worker2         36m          0%       486Mi           2%          
133-worker3         31m          0%       415Mi           1%   
```

### 5. Create autoscale namespace and deploy the app

```bash
kubectl apply -f apache-server-deployment.yaml 

namespace/autoscale created
deployment.apps/php-apache created
service/php-apache created
```

Expected output:
```bash
kubectl get all -n autoscale

NAME                                 READY   STATUS    RESTARTS   AGE
pod/apache-server-6487c65df8-fmllg   1/1     Running   0          4s

NAME                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/php-apache   ClusterIP   10.133.158.162   <none>        80/TCP    4s

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/apache-server   1/1     1            1           4s

NAME                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/apache-server-6487c65df8   1         1         1       4s
```

## Solution 

### Create HPA in autoscale namespace

```bash
kubectl apply -f HPA.yaml 

horizontalpodautoscaler.autoscaling/apache-server created
```

Expected output:
```bash
kubectl get hpa -A
NAMESPACE   NAME            REFERENCE                  TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
autoscale   apache-server   Deployment/apache-server   cpu: 0%/50%   1         4         1          36s
```

Check the config of hpa for verification:
```bash
kubectl describe hpa -A

Name:                                                  apache-server
Namespace:                                             autoscale
Labels:                                                <none>
Annotations:                                           <none>
CreationTimestamp:                                     Sun, 14 Sep 2025 18:15:18 +0700
Reference:                                             Deployment/apache-server
Metrics:                                               ( current / target )
  resource cpu on pods  (as a percentage of request): 0% (1m) / 50%
Min replicas:                                          1
Max replicas:                                          4
Behavior:
  Scale Up:
    Stabilization Window: 0 seconds
    Select Policy: Max
    Policies:
      - Type: Pods     Value: 4    Period: 15 seconds
      - Type: Percent  Value: 100  Period: 15 seconds
  Scale Down:
    Stabilization Window: 30 seconds
    Select Policy: Max
    Policies:
      - Type: Percent  Value: 100  Period: 15 seconds
```