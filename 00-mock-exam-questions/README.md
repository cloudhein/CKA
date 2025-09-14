# CKA 2025 Practice Questions - Comprehensive Study Guide

> **Certified Kubernetes Administrator (CKA) Exam Preparation**  
> Updated for 2025 exam format with enhanced focus on troubleshooting and real-world scenarios

## 📋 **Exam Overview**

The CKA exam tests your ability to perform the responsibilities of a Kubernetes administrator in a command-line environment. This collection covers all exam domains with realistic scenarios you'll encounter in the actual exam.

### **Exam Domains & Weights (2025)**
- **Cluster Architecture, Installation & Configuration**: 25%
- **Workloads & Scheduling**: 15%
- **Services & Networking**: 20%
- **Storage**: 10%
- **Troubleshooting**: 30%

### **Key Changes in 2025**
- Increased emphasis on troubleshooting scenarios
- More hands-on, practical questions
- Enhanced focus on storage provisioning
- Integration with modern tools (Helm, Kustomize, Gateway API)

---

## 🗂️ **Practice Questions by Domain**

### **🗄️ Storage (10%)**

#### **Question 1: Basic PVC Creation**
Create a PersistentVolumeClaim with:
- **Size**: 100Mi
- **Access mode**: ReadWriteOnce  
- **Storage class**: "local-path"

Then create a Pod that mounts this PVC at `/data` and verify the volume is automatically created and mounted.

**Skills Tested**: Dynamic provisioning, PVC creation, volume mounting

---

#### **Question 2: Custom StorageClass with Retain Policy**

**Part A**: Create StorageClass
- **Name**: fast-storage
- **Provisioner**: rancher.io/local-path
- **Reclaim Policy**: Retain
- **Volume Binding Mode**: Immediate (default)

**Part B**: Create PV and PVC
- PV must use the fast-storage StorageClass
- Configure node affinity (so Kubernetes knows where to create the volume)
- PVC should bind to that specific PV
- **Key Test**: When PVC is deleted, PV should remain in Released state (due to Retain policy)

**Skills Tested**: Custom storage classes, reclaim policies, node affinity

---

#### **Question 3: Static PV Creation**
Manually create a PersistentVolume that:
- **Name**: static-pv-example
- **Size**: 200Mi
- **Type**: hostPath on node-1
- **Access mode**: ReadWriteOnce
- **Reclaim policy**: Retain

Then create a matching PersistentVolumeClaim (`static-pvc-example`) to bind to it.

**Skills Tested**: Static provisioning, hostPath volumes, PV/PVC binding

---

#### **Question 8: StatefulSet with Persistent Storage**
Deploy a StatefulSet named `web` with:
- **Replicas**: 2
- **Image**: nginx
- **Storage**: Each pod should have its own 1Gi persistent volume for `/usr/share/nginx/html`
- **Requirements**: Stable network identities and persistent storage that remains associated with the ordinal index

Create a Headless Service named `web` to facilitate stable networking for the StatefulSet.

**Skills Tested**: StatefulSets, persistent storage, headless services, stable networking

---

### **⚙️ Workloads & Scheduling (15%)**

#### **Question 4: Horizontal Pod Autoscaling**
Deploy a sample workload and configure Horizontal Pod Autoscaling:
- **Target**: Existing deployment `cpu-demo`
- **Scale range**: 1 to 5 replicas
- **Trigger**: Average CPU utilization exceeds 50%

**Skills Tested**: HPA configuration, resource metrics, autoscaling

---

#### **Question 5: Node Selection with Labels**
Create a pod named `nginx` with image `nginx:latest` and ensure it gets scheduled on nodes that have a label `disktype=ssd`.

**Skills Tested**: Node selectors, pod scheduling, label-based scheduling

---

#### **Question 7: Taints and Tolerations**
- **Task 1**: Add a taint to `node-1` so that no normal pods can schedule there
- **Task 2**: Schedule a Pod on that node by adding the appropriate toleration to the Pod spec
- **Task 3**: Ensure the Pod actually lands on `node-2`

**Skills Tested**: Taints, tolerations, node scheduling control

---

### **🔐 Security (Focus Area)**

#### **Question 6: Pod Security Standards**
Enforce the **Restricted** Pod Security Standard on the namespace `restricted-ns`. Pods in that namespace cannot:
- Have privileged access
- Use host networking  
- Have any elevated rights

**Skills Tested**: Pod Security Standards, namespace security policies

---

### **🌐 Services & Networking (20%)**

#### **Question 10: Custom DNS Configuration**
Cluster workloads need to resolve a custom domain internally.
- **Objective**: Configure CoreDNS such that any DNS query for `myapp.internal` returns the IP address `10.10.10.10`
- **Verification**: After configuration, pods in the cluster should be able to resolve `myapp.internal` to `10.10.10.10`

**Skills Tested**: CoreDNS configuration, custom DNS entries, DNS troubleshooting

---

#### **Question 13: Gateway API Implementation**
Your cluster uses the Gateway API for ingress traffic.
- **Service**: `web-service` running in the `default` namespace on port 80
- **Available**: Gateway API-compatible controller and GatewayClass named `example-gw-class`
- **Objective**: Expose `web-service` externally on HTTP port 80, routed via hostname `web.example.com`

**Skills Tested**: Gateway API, modern ingress patterns, service exposure

---

### **🔧 Troubleshooting (30%)**

#### **Question 9: CoreDNS Troubleshooting**
DNS lookups are failing in the cluster. Investigate and repair CoreDNS.

**Skills Tested**: DNS troubleshooting, CoreDNS debugging, cluster diagnostics

---

### **⚡ Installation & Configuration (25%)**

#### **Question 11: Helm Deployment**
Use Helm to deploy the Traefik Ingress Controller:
- **Namespace**: `traefik` (dedicated)
- **Release name**: `traefik`
- **Special requirement**: Enable Traefik's support for the Kubernetes Gateway API via Helm values

**Skills Tested**: Helm operations, ingress controller deployment, configuration management

---

#### **Question 12: Kustomize Deployment**
You have base manifests for an app in `/home/student/kustomize/base`.  
Use Kustomize to deploy a production variant with:
1. Add label `environment: production` to all resources
2. Prefix resource names with `prod-`
3. Use Nginx image tag `1.21` instead of the base's `1.19`

**Skills Tested**: Kustomize, configuration management, environment-specific deployments

---

#### **Question 14: Resource Limits and LimitRanges**
In the namespace `limit-test`, enforce default resource limits and requests:
- **Default requests**: 100m CPU and 50Mi memory
- **Default limits**: 200m CPU and 100Mi memory  
- **Maximum limit**: No container can request more than 500Mi memory
- **Application**: These defaults apply when containers don't specify their own limits

**Skills Tested**: LimitRange, resource management, namespace policies

---

> **Good luck with your CKA exam preparation! Remember: Practice makes perfect, and hands-on experience is your best teacher.**