# CKA 2025 Exam Questions - Complete Study Guide

> **Certified Kubernetes Administrator (CKA) Practice Questions**  
> Comprehensive collection of realistic exam scenarios covering all CKA domains

## Overview

This collection contains 17 comprehensive CKA practice questions that mirror the actual exam format and difficulty. Each question is designed to test multiple skills and real-world Kubernetes administration scenarios.

### Exam Domains Coverage
- **Installation & Configuration**: 25% (Questions 1, 7, 12, 15)
- **Workloads & Scheduling**: 15% (Questions 3, 8, 11, 13)  
- **Services & Networking**: 20% (Questions 2, 4, 5, 6, 9, 17)
- **Storage**: 10% (Question 10, 14)
- **Troubleshooting**: 30% (Questions 14, 16)

---

## Questions by Domain

### Installation & Configuration (25%)

#### **Question 1: NGINX TLS Configuration**
An NGINX Deploy named `nginx-static` is running in the `nginx-static` namespace. It is configured using a ConfigMap named `nginx-config`. 

**Task**: Update the `nginx-config` ConfigMap to allow only TLSv1.3 connections. Re-create, restart, or scale resources as necessary.

**Verification**: Test the changes using the following command (should fail as TLSv1.2 is no longer allowed):
```bash
curl --tls-max 1.2 https://web.k8s.local/
```

---

#### **Question 7: Argo CD Helm Installation**
Install Argo CD in the cluster using Helm.

**Tasks**:
1. Add the official Argo CD Helm repository with the name `argo`:
   ```
   https://argoproj.github.io/argo-helm
   ```
2. The Argo CD CRDs have already been pre-installed in the cluster
3. Generate a Helm template of the Argo CD Helm chart version `7.7.3` for the `argocd` namespace and save to `/argo-helm.yaml`
4. Configure the chart to not install CRDs
5. Install Argo CD using Helm with release name `argocd` using version `7.7.3`
6. Install it in the `argocd` namespace and configure it to not install CRDs

**Note**: You do not need to configure access to the Argo CD server UI.

---

#### **Question 12: Cert-Manager CRD Verification**
Verify the cert-manager application which has been deployed in the cluster.

**Tasks**:
1. Create a list of all cert-manager Custom Resource Definitions (CRDs) and save it to `~/resources.yaml`
2. Use kubectl's default output format to list CRDs (do not set an output format)
3. Using kubectl, extract the documentation for the subject specification field of the Certificate Custom Resource and save it to `~/subject.yaml`

**Important**: You may use any output format that kubectl supports for the documentation extraction.

---

#### **Question 15: Linux System Preparation for Kubernetes**
Prepare a Linux system for Kubernetes. Docker is already installed, but you need to configure it for kubeadm.

**Tasks**:

**Set up cri-dockerd**:
- Install the Debian package: `~/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb`
- Debian packages are installed using `dpkg`
- Enable and start the cri-docker service

**Configure system parameters**:
- Set `net.bridge.bridge-nf-call-iptables` to `1`
- Set `net.ipv6.conf.all.forwarding` to `1`
- Set `net.ipv4.ip_forward` to `1`
- Set `net.netfilter.nf_conntrack_max` to `131072`

---

### Workloads & Scheduling (15%)

#### **Question 3: Horizontal Pod Autoscaler Configuration**
Create a new HorizontalPodAutoscaler (HPA) named `apache-server` in the `autoscale` namespace.

**Requirements**:
- Target the existing Deployment called `apache-server` in the `autoscale` namespace
- Set the HPA to target 50% CPU usage per Pod
- Configure minimum 1 Pod and maximum 4 Pods
- Set the downscale stabilization window to 30 seconds

---

#### **Question 8: PriorityClass and Deployment Patching**
Create a new PriorityClass named `high-priority` for user-workloads with a value that is one less than the highest existing user-defined priority class value.

**Tasks**:
1. Patch the existing Deployment `busybox-logger` running in the `priority` namespace to use the high-priority priority class
2. Ensure that the `busybox-logger` Deployment rolls out successfully with the new priority class set
3. It is expected that Pods from other Deployments running in the priority namespace are evicted
4. Do not modify other Deployments running in the priority namespace

**Warning**: Failure to follow these requirements may result in a reduced score.

---

#### **Question 11: Sidecar Container Integration**
A legacy app needs to be integrated into the Kubernetes built-in logging architecture (i.e., `kubectl logs`). Adding a streaming co-located container is a good and common way to accomplish this requirement.

**Task**: Update the existing Deployment `synergy-deployment`, adding a co-located container named `sidecar` using the `busybox:stable` image to the existing Pod.

**Requirements**:
- The new co-located container must run the following command:
  ```bash
  /bin/sh -c "tail -n+1 -f /var/log/synergy-deployment.log"
  ```
- Use a Volume mounted at `/var/log` to make the log file `synergy-deployment.log` available to the co-located container
- Do not modify the specification of the existing container other than adding the required volume mount

**Hint**: Use a shared volume to expose the log file between the main application container and the sidecar.

---

#### **Question 13: WordPress Resource Allocation**
A WordPress application with 3 replicas in the `relative-fawn` namespace consists of:
- **CPU**: 1 core
- **Memory**: 2015360ki

**Tasks**:
- Divide node resources evenly across all 3 pods
- Give each Pod a fair share of CPU and memory
- Add enough overhead to keep the node stable
- Use the exact same requests for both containers and init containers
- You are not required to change any resource limits

**Helpful Tip**: It may help to temporarily scale the WordPress Deployment to 0 replicas while updating the resource requests.

**Verification**:
- WordPress keeps 3 replicas
- All Pods are running and ready

---

### Services & Networking (20%)

#### **Question 2: Ingress to Gateway API Migration**
Migrate an existing web application from Ingress to Gateway API while maintaining HTTP functionality.

**Given**: A GatewayClass named `nginx` is installed in the cluster.

**Tasks**:
1. Create a Gateway named `web-gateway` with hostname `gateway.web.k8s.local` that maintains the existing TLS and listener configuration from the existing ingress resource named `web`
2. Create an HTTPRoute named `web-route` with hostname `gateway.web.k8s.local` that maintains the existing routing rules from the current Ingress resource named `web`
3. Delete the existing Ingress resource named `web`

**Verification**: Test your Gateway API configuration with:
```bash
curl https://gateway.web.k8s.local/
```

---

#### **Question 4: Ingress Resource Creation**
Create a new Ingress resource `echo` in the `echo-sound` namespace.

**Requirements**:
- Expose Service `echoserver-service` on `http://example.org/echo`
- Use Service port `8080`

**Verification**: The availability of Service `echoserver-service` can be checked using the following command (should return 200):
```bash
curl -o /dev/null -s -w "%{http_code}\n" http://example.org/echo
```

---

#### **Question 5: Container Network Interface (CNI) Installation**
Install and configure a Container Network Interface (CNI) of your choice that meets the specified requirements.

**Choose one of the following CNI options**:

**Flannel (v0.26.1)** using the manifest:
```
https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml
```

**Calico (v3.28.2)** using the manifest:
```
https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml
```

**Requirement**: Ensure the selected CNI is properly installed and configured in the Kubernetes cluster.

---

#### **Question 6: CNI Installation with Network Policy Support**
Install and configure a Container Network Interface (CNI) of your choice that meets the specified requirements.

**Choose one of the following CNI options**:

**Flannel** using the manifest:
```
https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml
```

**Calico** using the manifest:
```
https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml
```

**The CNI you choose must**:
- Let Pods communicate with each other
- Support Network Policy enforcement
- Install from manifest files (do not use Helm)

---

#### **Question 9: Service Exposure and NodePort Configuration**
Reconfigure the existing Deployment `front-end` in namespace `sp-culator` to expose port 80/tcp of the existing container nginx.

**Tasks**:
1. Create a new Service named `front-end-svc` exposing the container port 80/tcp
2. Configure the new Service to also expose the individual pods via NodePort

---

#### **Question 17: Network Policy Implementation**
You have frontend and backend Deployments in separate namespaces (`frontend` and `backend`). They need to communicate.

**Tasks**:
1. **Analyze**: Inspect the frontend and backend Deployments to understand their communication requirements
2. **Apply**: From the NetworkPolicy YAML files in the `~/netpol` folder, choose one to apply. It must:
   - Allow communication between frontend and backend
   - Be as restrictive as possible (least permissive)

**Important**: Do not delete or change the existing "deny-all" network policies. Failure to follow these rules may result in a score reduction or zero.

---

### Storage (10%)

#### **Question 10: StorageClass Configuration**
Create a new StorageClass named `low-latency` that uses the existing provisioner `rancher.io/local-path`.

**Requirements**:
- Set the VolumeBindingMode to `WaitForFirstConsumer` (Mandatory - score will be reduced if not set)
- Make the newly created StorageClass (`low-latency`) the default StorageClass in the cluster
- Do NOT modify any existing Deployments or PersistentVolumeClaims (score will be reduced if modified)

---

### Troubleshooting (30%)

#### **Question 14: MariaDB Data Recovery**
A user accidentally deleted the MariaDB Deployment in the `mariadb` namespace, which was configured with persistent storage.

**Responsibility**: Re-establish the Deployment while ensuring data is preserved by reusing the available PersistentVolume.

**Given**: A PersistentVolume already exists and is retained for reuse (only one PV exists).

**Tasks**:
1. Create a PersistentVolumeClaim (PVC) named `mariadb` in the `mariadb` namespace with the spec:
   - Access mode: `ReadWriteOnce`
   - Storage: `250Mi`
2. Edit the MariaDB Deploy file located at `~/mariadb-deploy.yaml` to use the PVC created in the previous step
3. Apply the updated Deployment file to the cluster
4. Ensure the MariaDB Deployment is running and stable

---

#### **Question 16: Cluster Component Recovery**
Fix a single-node cluster that got broken during machine migration.

**Background**: The decommissioned cluster used an external etcd server.

**Tasks**:
1. Identify the broken cluster components and investigate what caused them to break
2. Fix the configuration of all broken cluster components
3. Restart all necessary services and components for changes to take effect
4. Ensure the cluster, single node, and all pods are Ready

---

## Study Tips

### Time Management
- **Easy questions**: 5-8 minutes each
- **Medium questions**: 8-12 minutes each  
- **Complex questions**: 12-20 minutes each
- **Total exam time**: 2 hours

### Key Success Factors
1. **Read requirements carefully** - many questions have specific constraints
2. **Verify your work** - most questions include verification commands
3. **Use imperative commands** when possible for speed
4. **Practice realistic scenarios** - these questions mirror real exam complexity
5. **Master kubectl** - essential for efficient execution

### Domain Focus Areas
- **Troubleshooting** (30%): Practice systematic debugging approaches
- **Installation & Configuration** (25%): Know cluster setup and tool integration
- **Services & Networking** (20%): Master service types, ingress, and network policies
- **Workloads & Scheduling** (15%): Understand deployments, scaling, and resource management
- **Storage** (10%): Know PV/PVC lifecycle and storage classes

---

## Verification Commands Reference

Most questions include specific verification commands. Always run these to confirm your solution works correctly before moving to the next question.

**Remember**: The CKA exam is performance-based. These questions test your ability to solve real-world Kubernetes administration challenges under time pressure.