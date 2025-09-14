# Kubernetes Horizontal Pod Autoscaler (HPA) Setup and Testing Guide

This guide demonstrates how to set up and test Horizontal Pod Autoscaler (HPA) in Kubernetes, including metrics-server installation, application deployment, and load testing.

## Prerequisites

- Kubernetes cluster (tested on Kind cluster)
- Helm package manager
- kubectl configured to access your cluster

## Table of Contents

1. [Metrics Server Installation](#metrics-server-installation)
2. [Application Deployment](#application-deployment)
3. [HPA Configuration](#hpa-configuration)
4. [Load Testing](#load-testing)
5. [Monitoring and Verification](#monitoring-and-verification)
6. [Scaling Behavior](#scaling-behavior)
7. [Troubleshooting](#troubleshooting)

## Metrics Server Installation

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

> **Note**: The `--kubelet-insecure-tls` flag is used to skip TLS certificate verification when connecting to kubelets. This is common in development environments with self-signed certificates.

### 3. Verify Installation

```bash
kubectl get all -n kube-system -l app.kubernetes.io/name=metrics-server
```

Expected output:
```
NAME                                  READY   STATUS    RESTARTS   AGE
pod/metrics-server-5dd7b49d79-vfjpx   1/1     Running   0          6m49s

NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/metrics-server   ClusterIP   10.133.77.165   <none>        443/TCP   6m49s

NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/metrics-server   1/1     1            1           6m49s

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/metrics-server-5dd7b49d79   1         1         1       6m49s
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
```
NAME                CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)   
133-control-plane   191m         1%       723Mi           3%          
133-worker          46m          0%       288Mi           1%          
133-worker2         35m          0%       206Mi           0%          
133-worker3         40m          0%       510Mi           2%
```

## Application Deployment

Deploy the required applications for HPA testing:

### 1. Deploy Application and Service

```bash
kubectl apply -f deployment.yaml 
kubectl apply -f traffic-generator.yaml 
```

### 2. Deploy HPA Configuration

```bash
kubectl apply -f hpa.yaml 
```

### 3. Verify Deployment

```bash
kubectl get all
```

Expected initial state:
```
NAME                               READY   STATUS    RESTARTS   AGE
pod/traffic-generator              1/1     Running   0          46s
pod/utility-api-648c95fbb8-zbwfx   1/1     Running   0          54s

NAME                          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/kubernetes            ClusterIP   10.133.0.1       <none>        443/TCP    4h50m
service/utility-api-service   ClusterIP   10.133.134.116   <none>        8080/TCP   54s

NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/utility-api   1/1     1            1           54s
```

## HPA Configuration

The HPA is configured with the following parameters:

- **Target**: `Deployment/utility-api`
- **CPU Threshold**: 50%
- **Min Pods**: 1
- **Max Pods**: 5
- **Scale Down Delay**: 300 seconds (5 minutes) - default Kubernetes behavior

## Load Testing

### 1. Start Load Testing

Access the traffic generator pod and run load tests:

```bash
kubectl exec -it traffic-generator -- sh
```

Inside the pod, run:

```bash
wrk -t5 -c5 -d300s -H "HPA Test" http://utility-api-service:8080/api/stress
```

Parameters:
- `-t5`: 5 threads
- `-c5`: 5 connections
- `-d300s`: Run for 300 seconds (5 minutes)
- `-H "HPA Test"`: Custom header

### 2. Monitor Resource Usage During Load

```bash
kubectl top pods
```

Under load, you'll see high CPU usage:
```
NAME                           CPU(cores)   MEMORY(bytes)
traffic-generator              97m          12Mi
utility-api-648c95fbb8-864vw   506m         248Mi
utility-api-648c95fbb8-8nhrp   699m         219Mi
utility-api-648c95fbb8-ssqkf   913m         199Mi
utility-api-648c95fbb8-vkvrw   725m         314Mi
utility-api-648c95fbb8-zbwfx   360m         320Mi
```

## Monitoring and Verification

### 1. Check HPA Status

```bash
kubectl get hpa
```

During scaling:
```
NAME              REFERENCE                TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
utility-api-hpa   Deployment/utility-api   cpu: 256%/50%   1         5         5          2m29s
```

### 2. Monitor Scaling Events

```bash
kubectl describe hpa utility-api-hpa
```

### 3. Watch Pod Scaling in Real-time

```bash
kubectl get pods -w
```

## Scaling Behavior

### Scale-Out Behavior

- **Trigger**: CPU usage > 50%
- **Response**: HPA creates additional pods up to maximum (5 pods)
- **Speed**: New pods are created within 1-2 minutes

### Scale-In Behavior

- **Trigger**: CPU usage < 50%
- **Delay**: Default 300 seconds (5 minutes) stabilization period
- **Target**: Scales down to minimum required pods (1 pod)

Example of scale-down:
```
NAME              REFERENCE                TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
utility-api-hpa   Deployment/utility-api   cpu: 1%/50%   1         5         1          9m22s
```

## Scaling Timeline

| Phase | Duration | Action | Pod Count |
|-------|----------|---------|-----------|
| Initial | 0-1min | Application starts | 1 |
| Load Start | 1-2min | Traffic begins, CPU rises | 1 |
| Scale Out | 2-4min | HPA detects high CPU, scales up | 2-5 |
| Steady State | 4-8min | Load continues, pods handle traffic | 5 |
| Load Stop | 8-9min | Traffic stops, CPU drops | 5 |
| Scale Down | 9-14min | HPA waits 5min, then scales down | 5→1 |

## Troubleshooting

### Common Issues

1. **HPA shows `<unknown>` targets**
   ```bash
   # Check if metrics-server is running
   kubectl get pods -n kube-system | grep metrics-server
   
   # Check metrics-server logs
   kubectl logs -n kube-system deployment/metrics-server
   ```

2. **Pods not scaling**
   ```bash
   # Verify HPA configuration
   kubectl describe hpa utility-api-hpa
   
   # Check deployment resource requests
   kubectl describe deployment utility-api
   ```

3. **Metrics not available**
   ```bash
   # Test metrics collection
   kubectl top pods
   kubectl top nodes
   ```

### Verification Commands

```bash
# Check all components
kubectl get all
kubectl get hpa
kubectl top pods

# Monitor scaling events
kubectl get events --sort-by=.metadata.creationTimestamp

# Detailed HPA information
kubectl describe hpa utility-api-hpa
```

## Best Practices

1. **Always set resource requests** in your deployment for HPA to work correctly
2. **Use appropriate CPU thresholds** (typically 50-80%)
3. **Set reasonable min/max pod limits** to prevent resource exhaustion
4. **Monitor scaling behavior** during load testing
5. **Consider custom metrics** for more sophisticated scaling decisions

## Cleanup

To remove all components:

```bash
kubectl delete -f hpa.yaml
kubectl delete -f traffic-generator.yaml  
kubectl delete -f deployment.yaml
helm uninstall metrics-server -n kube-system
```

---

**Note**: This guide was tested on a Kind cluster with Kubernetes. Adjust configurations based on your specific cluster setup and requirements.