## Check the error logs of CoreDNS service of k8s

### Coredns service is in CrashLoopBackOff
```bash
kubectl get pods -n kube-system | grep coredns
coredns-676df57967-cs6l8                    0/1     CrashLoopBackOff   4 (30s ago)   2m2s
coredns-676df57967-vw8bb                    0/1     CrashLoopBackOff   4 (34s ago)   2m2s
```

### Check the logs of CoreDNS pod 
```bash
kubectl logs pod/coredns-676df57967-cs6l8 -n kube-system
maxprocs: Leaving GOMAXPROCS=16: CPU quota undefined
/etc/coredns/Corefile:7 - Error during parsing: Unknown directive 'kubernetess'
```

## Modify the configmap of CoreDNS to resolve the errors

```bash
kubectl get configmap -n kube-system | grep coredns
coredns                                                1      27h
```

### Fix the typo errors of ***kubernetess*** to ***kubernetes*** in configmap of CoreDNS 
```bash
kubectl edit configmap/coredns -n kube-system

kubernetes cluster.local in-addr.arpa ip6.arpa {
```

## Do rollout restart the deployment of coredns service to resolve the errors

```bash
kubectl rollout restart deployment/coredns -n kube-system
deployment.apps/coredns restarted
```

#### CoreDNS pods have resolved errors and up & running successfully 

```bash
kubectl get pods -n kube-system  | grep coredns
coredns-cc7599666-6jj2g                     1/1     Running   0              101s
coredns-cc7599666-8l8rr                     1/1     Running   0              101s
```


