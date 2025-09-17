# Calico CNI Installation & Network Policy Guide

> **Complete walkthrough of installing Calico CNI and implementing network policies in Kubernetes**  
> Perfect for CKA exam preparation and production cluster setup

## 📋 **Overview**

This guide demonstrates the complete process of:
- Installing Calico CNI on a fresh Kubernetes cluster
- Understanding the impact of CNI on cluster functionality
- Testing network connectivity between pods
- Implementing network policies for security

---

## 🚨 **Initial State: Cluster Without CNI**

### **Node Status Before CNI Installation**

When you start a Kubernetes cluster without installing a CNI, all nodes remain in `NotReady` status:

```bash
kubectl get nodes
```

**Expected Output:**
```bash
NAME                STATUS     ROLES           AGE     VERSION
133-control-plane   NotReady   control-plane   2m17s   v1.33.1
133-worker          NotReady   <none>          2m6s    v1.33.1
133-worker2         NotReady   <none>          2m7s    v1.33.1
133-worker3         NotReady   <none>          2m7s    v1.33.1
```

### **Pod Status Before CNI Installation**

Critical system pods remain in `Pending` state without CNI:

```bash
kubectl get pods -o wide -A | grep Pending
```

**Expected Output:**
```bash
kube-system          coredns-674b8bbfcf-9dkzj                    0/1     Pending   0          4m56s   <none>       <none>              <none>           <none>
kube-system          coredns-674b8bbfcf-9dn9b                    0/1     Pending   0          4m56s   <none>       <none>              <none>           <none>
local-path-storage   local-path-provisioner-7dc846544d-m66np     0/1     Pending   0          4m56s   <none>       <none>              <none>           <none>
metallb-system       controller-bb5f47665-ggdgb                  0/1     Pending   0          4m52s   <none>       <none>              <none>           <none>
```

> **Key Insight**: Without CNI, Kubernetes cannot assign IP addresses to pods or enable pod-to-pod communication across nodes.

---

## 🛠️ **Installing Calico CNI**

### **Why Choose Calico?**

Calico is selected for this installation because it provides:
- **Powerful network policy features**
- **BGP-based routing for high performance**
- **Support for both overlay and non-overlay networking**
- **Comprehensive security features**

### **Step 1: Install Tigera Operator**

The Tigera Operator manages the Calico installation and lifecycle:

```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml
```

**Expected Output:**
```bash
namespace/tigera-operator created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgpfilters.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/caliconodestatuses.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipreservations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/tiers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/adminnetworkpolicies.policy.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/apiservers.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/imagesets.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/installations.operator.tigera.io created
customresourcedefinition.apiextensions.k8s.io/tigerastatuses.operator.tigera.io created
serviceaccount/tigera-operator created
clusterrole.rbac.authorization.k8s.io/tigera-operator created
clusterrolebinding.rbac.authorization.k8s.io/tigera-operator created
deployment.apps/tigera-operator created
```

### **Step 2: Verify Tigera Operator Installation**

Check that the Tigera Operator is running:

```bash
kubectl get all -n tigera-operator
```

**Expected Output:**
```bash
NAME                                  READY   STATUS    RESTARTS   AGE
pod/tigera-operator-ccfc44587-m6rwd   1/1     Running   0          2m33s

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/tigera-operator   1/1     1            1           2m33s

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/tigera-operator-ccfc44587   1         1         1       2m33s
```

### **Step 3: Examine Calico Custom Resource Definitions**

The operator creates numerous CRDs for Calico functionality:

```bash
kubectl get crds | grep -v 'metallb'
```

**Expected Output:**
```bash
NAME                                                  CREATED AT
adminnetworkpolicies.policy.networking.k8s.io         2025-09-15T22:18:09Z
apiservers.operator.tigera.io                         2025-09-15T22:18:09Z
bgpconfigurations.crd.projectcalico.org               2025-09-15T22:18:08Z
bgpfilters.crd.projectcalico.org                      2025-09-15T22:18:08Z
bgppeers.crd.projectcalico.org                        2025-09-15T22:18:08Z
blockaffinities.crd.projectcalico.org                 2025-09-15T22:18:08Z
caliconodestatuses.crd.projectcalico.org              2025-09-15T22:18:08Z
clusterinformations.crd.projectcalico.org             2025-09-15T22:18:09Z
felixconfigurations.crd.projectcalico.org             2025-09-15T22:18:09Z
globalnetworkpolicies.crd.projectcalico.org           2025-09-15T22:18:09Z
globalnetworksets.crd.projectcalico.org               2025-09-15T22:18:09Z
hostendpoints.crd.projectcalico.org                   2025-09-15T22:18:09Z
imagesets.operator.tigera.io                          2025-09-15T22:18:09Z
installations.operator.tigera.io                      2025-09-15T22:18:09Z
ipamblocks.crd.projectcalico.org                      2025-09-15T22:18:09Z
ipamconfigs.crd.projectcalico.org                     2025-09-15T22:18:09Z
ipamhandles.crd.projectcalico.org                     2025-09-15T22:18:09Z
ippools.crd.projectcalico.org                         2025-09-15T22:18:09Z
ipreservations.crd.projectcalico.org                  2025-09-15T22:18:09Z
kubecontrollersconfigurations.crd.projectcalico.org   2025-09-15T22:18:09Z
networkpolicies.crd.projectcalico.org                 2025-09-15T22:18:09Z
networksets.crd.projectcalico.org                     2025-09-15T22:18:09Z
tiers.crd.projectcalico.org                           2025-09-15T22:18:09Z
tigerastatuses.operator.tigera.io                     2025-09-15T22:18:09Z
```

---

## ⚙️ **Configuring Calico Installation**

### **Step 4: Download and Customize Installation Manifest**

```bash
curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/custom-resources.yaml > install-calico.yml
```

### **Step 5: Modify Configuration According to Your Requirements**

**install-calico.yml**
```yaml
# This section includes base Calico installation configuration.
# For more information, see: https://docs.tigera.io/calico/latest/reference/installation/api#operator.tigera.io/v1.Installation
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  # Configures Calico networking.
  calicoNetwork:
    ipPools:
    - name: default-ipv4-ippool
      blockSize: 26
      cidr: 10.253.0.0/16 # Change this to match the podSubnet in your kind config
      encapsulation: VXLANCrossSubnet
      natOutgoing: Enabled
      nodeSelector: all()

---

# This section configures the Calico API server.
# For more information, see: https://docs.tigera.io/calico/latest/reference/installation/api#operator.tigera.io/v1.APIServer
apiVersion: operator.tigera.io/v1
kind: APIServer
metadata:
  name: default
spec: {}
```

> **Important Configuration Notes:**
> - **CIDR**: Set to match your cluster's pod subnet (10.253.0.0/16)
> - **blockSize**: 26 allows for efficient IP allocation
> - **encapsulation**: VXLANCrossSubnet provides overlay networking
> - **natOutgoing**: Enables pods to reach external networks

### **Step 6: Apply Calico Configuration**

```bash
kubectl create -f install-calico.yml 
```

**Expected Output:**
```bash
installation.operator.tigera.io/default created
apiserver.operator.tigera.io/default created
```

---

## ✅ **Post-Installation Verification**

### **Cluster Nodes Status After CNI Installation**

All nodes should now be in `Ready` status:

```bash
kubectl get nodes
```

**Expected Output:**
```bash
NAME                STATUS   ROLES           AGE   VERSION
133-control-plane   Ready    control-plane   25m   v1.33.1
133-worker          Ready    <none>          25m   v1.33.1
133-worker2         Ready    <none>          25m   v1.33.1
133-worker3         Ready    <none>          25m   v1.33.1
```

### **All Pods Running After CNI Installation**

Check that all system pods are now running:

```bash
kubectl get pods -A
```

**Expected Output:**
```bash
NAMESPACE            NAME                                        READY   STATUS    RESTARTS   AGE
calico-apiserver     calico-apiserver-7577878857-brtps           1/1     Running   0          6m7s
calico-apiserver     calico-apiserver-7577878857-cd4sm           1/1     Running   0          6m7s
calico-system        calico-kube-controllers-568fd699bc-vq2vr    1/1     Running   0          6m7s
calico-system        calico-node-jj8gc                           1/1     Running   0          6m7s
calico-system        calico-node-n7vjp                           1/1     Running   0          6m7s
calico-system        calico-node-vbtgp                           1/1     Running   0          6m7s
calico-system        calico-node-zwf5l                           1/1     Running   0          6m7s
calico-system        calico-typha-776c95dbbd-bd6fv               1/1     Running   0          6m7s
calico-system        calico-typha-776c95dbbd-dd2mq               1/1     Running   0          6m7s
calico-system        csi-node-driver-hbmx9                       2/2     Running   0          6m7s
calico-system        csi-node-driver-qhnj5                       2/2     Running   0          6m7s
calico-system        csi-node-driver-x4dnw                       2/2     Running   0          6m7s
calico-system        csi-node-driver-xb5z8                       2/2     Running   0          6m7s
kube-system          coredns-674b8bbfcf-9dkzj                    1/1     Running   0          28m
kube-system          coredns-674b8bbfcf-9dn9b                    1/1     Running   0          28m
kube-system          etcd-133-control-plane                      1/1     Running   0          28m
kube-system          kube-apiserver-133-control-plane            1/1     Running   0          28m
kube-system          kube-controller-manager-133-control-plane   1/1     Running   0          28m
kube-system          kube-proxy-kncms                            1/1     Running   0          28m
kube-system          kube-proxy-lx4j6                            1/1     Running   0          28m
kube-system          kube-proxy-sj5cd                            1/1     Running   0          28m
kube-system          kube-proxy-wcqzr                            1/1     Running   0          28m
kube-system          kube-scheduler-133-control-plane            1/1     Running   0          28m
local-path-storage   local-path-provisioner-7dc846544d-m66np     1/1     Running   0          28m
metallb-system       controller-bb5f47665-ggdgb                  1/1     Running   0          28m
metallb-system       speaker-8s5r9                               1/1     Running   0          4m58s
metallb-system       speaker-fcpwt                               1/1     Running   0          5m7s
metallb-system       speaker-h8qqr                               1/1     Running   0          4m36s
metallb-system       speaker-mcs9g                               1/1     Running   0          5m5s
tigera-operator      tigera-operator-ccfc44587-m6rwd             1/1     Running   0          19m
```

> **Key Observation**: CoreDNS pods that were previously `Pending` are now `Running`, enabling DNS resolution in the cluster.

---

## 🧪 **Testing Network Connectivity**

### **Step 1: Create Test Namespace**

Create a dedicated namespace for testing:

```bash
kubectl create namespace quickstart
```

### **Step 2: Deploy NGINX Web Server**

Deploy an NGINX web server in the quickstart namespace:

```bash
kubectl create deployment --namespace=quickstart nginx --image=nginx
```

**Verify Deployment:**
```bash
kubectl get all -n quickstart
```

**Expected Output:**
```bash
NAME                         READY   STATUS    RESTARTS   AGE
pod/nginx-5869d7778c-279ks   1/1     Running   0          24s

NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx   1/1     1            1           24s

NAME                               DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-5869d7778c   1         1         1       24s
```

### **Step 3: Expose NGINX Service**

Expose the NGINX deployment to make it accessible within the cluster:

```bash
kubectl expose --namespace=quickstart deployment nginx --port=80
```

### **Step 4: Test Internal Connectivity**

Start a BusyBox session to test whether you can access the NGINX server:

```bash
kubectl run --namespace=quickstart access --rm -ti --image busybox /bin/sh
```

#### **Test NGINX Service Access**

Access the nginx service from busybox pod:

```bash
If you don't see a command prompt, try pressing enter.
/ # wget -qO- http://nginx
```

**Expected Output:**
```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

#### **Test External Connectivity**

In the Busybox shell, test communication with the public internet (egress traffic is also allowed):

```bash
wget -qO- https://docs.tigera.io/pod-connection-test.txt
```

**Expected Output:**
```bash
You successfully connected to https://docs.tigera.io/pod-connection-test.txt.
```

> **Success!** Both internal service communication and external internet access are working properly.

---

## 🔒 **Implementing Network Security Policies**

### **Step 1: Create Default Deny Policy**

Restrict all traffic with a default deny policy:

```bash
kubectl create -f globalnetworkpolicy.yaml 
```

**Expected Output:**
```bash
globalnetworkpolicy.projectcalico.org/default.default-deny created
```

### **Step 2: Test Restricted Access**

Go back to your BusyBox shell and test access to the NGINX server & egress outbound access again:

```bash
kubectl run --namespace=quickstart access --rm -ti --image busybox /bin/sh
```

#### **Expected Output: No Connectivity to NGINX Service**

Due to network policy restriction:

```bash
If you don't see a command prompt, try pressing enter.
/ # wget -qO- http://nginx

wget: bad address 'nginx'
```

#### **Expected Output: No Connectivity to Public Internet**

Due to network policy restriction:

```bash
/ # wget -qO- https://docs.tigera.io/pod-connection-test.txt
wget: bad address 'docs.tigera.io'
```

> **Network Policy Working!** The default deny policy has successfully blocked all communication.

---

## 🎯 **Creating Targeted Allow Policies**

### **Step 3: Allow Specific Traffic Patterns**

Allow egress traffic in BusyBox POD and ingress traffic from busybox pod in NGINX POD:

```bash
kubectl apply -f allowed-traffic-busybox-networkpolicy.yaml
```

**Expected Output:**
```bash
networkpolicy.projectcalico.org/default.allow-busybox-egress created
```

```bash
kubectl apply -f allowed-traffic-nginx-networkpolicy.yaml 
```

**Expected Output:**
```bash
networkpolicy.projectcalico.org/default.allow-nginx-ingress created
```

### **Step 4: Verify Selective Access**

#### **Test Access to NGINX Server Again**

```bash
kubectl run --namespace=quickstart access --rm -ti --image busybox /bin/sh

If you don't see a command prompt, try pressing enter.
/ # wget -qO- http://nginx
```

**Expected Output:**
```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```

#### **Test Access to Public Internet Again**

```bash
kubectl run --namespace=quickstart access --rm -ti --image busybox /bin/sh

You successfully connected to https://docs.tigera.io/pod-connection-test.txt./
```

> **Perfect!** Targeted network policies are now allowing only the specific traffic patterns we've defined.

---

## 📚 **Key Learnings & Best Practices**

### **Critical Understanding Points**

1. **CNI is Essential**: Without CNI, Kubernetes clusters are non-functional
2. **Calico Provides Security**: Built-in network policy capabilities
3. **Operator Pattern**: Modern Calico uses operators for lifecycle management
4. **Testing is Crucial**: Always verify connectivity after CNI installation
5. **Security by Default**: Implement deny-all policies first, then allow specific traffic

### **Production Considerations**

- **IP Pool Planning**: Choose CIDR ranges that don't conflict with existing infrastructure
- **Encapsulation**: Consider VXLANCrossSubnet for mixed environments
- **Network Policies**: Implement defense-in-depth with layered policies
- **Monitoring**: Use Calico's observability features for network troubleshooting

### **CKA Exam Tips**

- **Practice CNI installation** in different scenarios
- **Understand the relationship** between CNI and node readiness
- **Master network policy syntax** for security questions
- **Know troubleshooting commands** for common CNI issues

---

## 🚀 **Next Steps**

After mastering this basic Calico installation:

1. **Explore Advanced Features**: BGP peering, IP-in-IP encapsulation
2. **Practice Network Policies**: More complex ingress/egress rules
3. **Learn Troubleshooting**: Common CNI issues and debugging techniques
4. **Study Integration**: How CNI works with services, ingress controllers
5. **Performance Tuning**: Optimizing network performance in large clusters

This foundation will serve you well in both CKA exam scenarios and real-world cluster administration!