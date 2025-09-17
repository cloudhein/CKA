## Setup Configuration and Important Notes

### Check the default priority class in your k8s cluster (system-level-priority-class & core components of control plane)

- System-level-priority-class `value` start from `2000000000`
- They have the highest priority to ensure that critical components are always scheduled first.

```bash
kubectl get pc
NAME                      VALUE        GLOBAL-DEFAULT   AGE   PREEMPTIONPOLICY
system-cluster-critical   2000000000   false            15h   PreemptLowerPriority
system-node-critical      2000001000   false            15h   PreemptLowerPriority
```

## Important Notes of priority class

- Application-level-priority-class `value` start from `-2147483648` to `1000000000`
- If priority class is not defined, the pod will get the priority class value `0`.
- If a PriorityClass has `globalDefault: true`, Pods without an explicitly assigned priority class will automatically get this priority.
- Only one `PriorityClass` with `globalDefault: true` can exist in the cluster.

### 🎯 **PreemptionPolicy Options**

#### **`PreemptLowerPriority` (Default)**
- **Behavior**: Can kill other existing workloads which have lower priority in the k8s cluster
- **Use Case**: Critical workloads that must run immediately
- **Impact**: Aggressive - evicts lower priority pods to make space

#### **`Never`**
- **Behavior**: Will not kill existing lower priority workloads and waits for cluster resources to free up
- **Use Case**: Important but not urgent workloads
- **Impact**: Gentle - waits for natural resource availability

---

### 📋 **Quick Example**

#### **Aggressive Preemption (Default)**
```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority-aggressive
value: 1000
preemptionPolicy: PreemptLowerPriority  # Kills lower priority pods
description: "Critical workload - evicts others if needed"
```

#### **Gentle Preemption** 
```yaml
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority-gentle
value: 1000
preemptionPolicy: Never  # Waits for resources to free up naturally
description: "Important but patient workload"
```

### Deploy priority class and deployment 

#### Create `priority` namespace

```bash
kubectl create namespace priority
```

#### Create different `priority class` in your k8s cluster 

```bash
kubectl apply -f priority-class.yaml 

priorityclass.scheduling.k8s.io/medium-priority created
priorityclass.scheduling.k8s.io/low-priority created
priorityclass.scheduling.k8s.io/very-high-priority created
```

EXPECTED OUTPUT:
```bash
kubectl get priorityclass --sort-by=.value

NAME                      VALUE        GLOBAL-DEFAULT   AGE   PREEMPTIONPOLICY
low-priority              100          false            87s   PreemptLowerPriority
medium-priority           500          false            87s   PreemptLowerPriority
very-high-priority        800          false            87s   PreemptLowerPriority
system-cluster-critical   2000000000   false            16h   PreemptLowerPriority
system-node-critical      2000001000   false            16h   PreemptLowerPriority
```

#### Deploy `busybox logger` application 

```bash
kubectl apply -f busybox-logger.yaml 
deployment.apps/busybox-logger created
``` 

#### Deploy other application in priority namespace

```bash
kubectl apply -f demo-priority.yaml 
deployment.apps/low-priority-app created
deployment.apps/medium-priority-app created
```
EXPECTED OUTPUT:
```bash
kubectl get all -n priority
NAME                                       READY   STATUS    RESTARTS   AGE
pod/busybox-logger-6565984f66-drvhz        1/1     Running   0          3m46s
pod/busybox-logger-6565984f66-f7f9w        1/1     Running   0          3m46s
pod/low-priority-app-5cff746956-hkbkv      1/1     Running   0          41s
pod/medium-priority-app-857dd6bc4c-cqmdh   1/1     Running   0          41s

NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/busybox-logger        2/2     2            2           3m46s
deployment.apps/low-priority-app      1/1     1            1           41s
deployment.apps/medium-priority-app   1/1     1            1           41s

NAME                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/busybox-logger-6565984f66        2         2         2       3m46s
replicaset.apps/low-priority-app-5cff746956      1         1         1       41s
replicaset.apps/medium-priority-app-857dd6bc4c   1         1         1       41s
```

## Solution Steps

### Create a new PriorityClass named `high-priority` 

```bash
kubectl apply -f high-priority.yaml 
priorityclass.scheduling.k8s.io/high-priority created
```
EXPECTED OUTPUT:
```bash
kubectl get priorityclass --sort-by=.value
NAME                      VALUE        GLOBAL-DEFAULT   AGE   PREEMPTIONPOLICY
low-priority              100          false            14m   PreemptLowerPriority
medium-priority           500          false            14m   PreemptLowerPriority
high-priority             799          false            42s   PreemptLowerPriority
very-high-priority        800          false            14m   PreemptLowerPriority
system-cluster-critical   2000000000   false            16h   PreemptLowerPriority
system-node-critical      2000001000   false            16h   PreemptLowerPriority
```

### Patch the existing Deployment `busybox-logger` running in the `priority` namespace to use the high-priority priority class.

```bash
kubectl edit deployment.apps/busybox-logger -n priority
deployment.apps/busybox-logger edited

##adding new priority class value
spec:
      priorityClassName: high-priority
```

### Rollout restart to busybox logger after updating with new priority class value
```bash
kubectl rollout restart deployment.apps/busybox-logger -n priority
deployment.apps/busybox-logger restarted
```

EXPECTED OUTPUT:
```bash
kubectl get all -n priority

NAME                                       READY   STATUS    RESTARTS   AGE
pod/busybox-logger-76fb5c4689-khkht        1/1     Running   0          41s
pod/busybox-logger-76fb5c4689-l52kn        1/1     Running   0          42s
pod/low-priority-app-5cff746956-hkbkv      1/1     Running   0          20m
pod/medium-priority-app-857dd6bc4c-cqmdh   1/1     Running   0          20m

NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/busybox-logger        2/2     2            2           23m
deployment.apps/low-priority-app      1/1     1            1           20m
deployment.apps/medium-priority-app   1/1     1            1           20m

NAME                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/busybox-logger-5df48987dc        0         0         0       10m
replicaset.apps/busybox-logger-6565984f66        0         0         0       23m
replicaset.apps/busybox-logger-76fb5c4689        2         2         2       42s
replicaset.apps/low-priority-app-5cff746956      1         1         1       20m
replicaset.apps/medium-priority-app-857dd6bc4c   1         1         1       20m
```