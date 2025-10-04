## Setup Configuration

### BREAK the Cluster by Modifying the kube-apiserver Static Pod

`The kube-apiserver is defined as a static Pod in:`

```bash
/etc/kubernetes/manifests/kube-apiserver.yaml
```

- Step 1: Make a backup

```bash
sudo cp /etc/kubernetes/manifests/kube-apiserver.yaml /etc/kubernetes/manifests/kube-apiserver.yaml.bak
```

- Step 2: Intentionally misconfigure etcd address

```bash
sudo sed -i 's|--etcd-servers=.*|--etcd-servers=https://10.255.255.1:2379|' /etc/kubernetes/manifests/kube-apiserver.yaml
```

- Step 3: Watch the damage

```bash
watch -n2 "docker ps | grep kube-apiserver"   # or crictl ps or journalctl -u kubelet
```
`crictl can be used to deugg Kubernetes nodes and  is a command-line interface for k8s container runtime interface`

## Solution Setup

```bash
journalctl -u kubelet -f

ls /etc/kubernetes/manifest/


vi /etc/kubernetes/manifest/kube-apiserver.yaml

>> etcd-servers=https://127.0.0.1:2379


sudo systemctl restart kubelet

sudo systemctl status kubelet
```
### **If you got the error of tls certicates even after updates kube-apiserver static pod, regenerate the API Server Certificate**

### **WARNINGS** 
- I have yet tested in the exam for this solution, please do further research and prepare in your own lab in case you got tls certicates errors 

```bash

rm /etc/kubernetes/pki/apiserver.crt /etc/kubernetes/pki/apiserver.key

kubeadm init phase certs apiserver
```
