# Setup Guide

## Create a namepsce 

```bash
kubectl create ns limit-test
namespace/limit-test created
```
# Solution

## Enforce default resource limits and requests for containers

```bash
kubectl apply -f limit-range.yaml 
limitrange/cpu-resource-constraint created
```

## Check the output 

```bash
kubectl describe ns limit-test

Name:         limit-test
Labels:       kubernetes.io/metadata.name=limit-test
Annotations:  <none>
Status:       Active

No resource quota.

Resource Limits
 Type       Resource  Min  Max    Default Request  Default Limit  Max Limit/Request Ratio
 ----       --------  ---  ---    ---------------  -------------  -----------------------
 Container  memory    -    500Mi  50Mi             100Mi          -
 Container  cpu       -    -      100m             200m           -
```