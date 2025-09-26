## Add the custom domain name records in coredns configmap

```bash
kubectl edit configmap/coredns -n kube-system

apiVersion: v1
data:
  Corefile: |
    myapp.internal:53 {
      errors
       hosts {
            10.10.10.10 myapp.internal
            fallthrough
        }
    }
```

## Do rollout restart of coredns deployment service 

```bash
kubectl rollout restart deployment/coredns -n kube-system 
deployment.apps/coredns restarted
```

## Depoly busybox application to test the custom domain name records

```bash
kubectl apply -f pods.yaml 
pod/busybox-pod created
```

```bash
 kubectl exec -it busybox-pod -- sh
/ # nslookup myapp.internal
Server:         10.133.0.10
Address:        10.133.0.10:53

Name:   myapp.internal
Address: 10.10.10.10
```
# Better Solution

## Add the custom domain records in configmap of coredns 

```bash
kubectl edit configmap/coredns -n kube-system

apiVersion: v1
data:
  Corefile: |
    .:53 {
        errors
        hosts {
          10.10.10.10 myapp.internal
          fallthrough
        }
```

## Do rollout restart of coredns deployment service 
```bash
kubectl rollout restart deployment/coredns -n kube-system 
deployment.apps/coredns restarted
```

## test the custom domain name records in busybox-pod

```bash
kubectl exec -it busybox-pod -- sh
/ # nslookup myapp.internal
Server:    10.133.0.10
Address 1: 10.133.0.10 kube-dns.kube-system.svc.cluster.local

Name:      myapp.internal
Address 1: 10.10.10.10 myapp.internal
```

