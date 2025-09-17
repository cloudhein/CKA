## Question 1

An NGINX Deploy named `nginx-static` is Running in the `nginx-static` NS. It is configured using a CfgMap named nginx-config. Update the nginx-config CfgMap to allow only TLSv1.3 connections.re-create, restart, or scale resources as necessary. By using command to test the changes:

[candidate@cka2025] $ curl --tls-max 1.2 [https://web.k8s.local](https://web.k8s.local/)

As TLSV1.2 should not be allowed anymore, the command should fail

## Question 2

Migrate an existing web application from Ingress to Gateway API.

We must maintain HTTPSuccess.

A GatewayClass named `nginx` is installed in the cluster.

First, create a Gateway named `web-gateway` with hostname gateway.web.k8s.local that maintains the existing TLS and listener configuration from the existing ingress resource named web.

Next, create an HTTPRoute named `web-route` with hostname gateway.web.k8s.local that maintains the existing routing rules from the current Ingress resource named web.

You can test your Gateway API configuration with the following command:

[candidate@cka2025] $ curl https:[//gateway.web.k8s.local](https://gateway.web.k8s.local/)

Finally, delete the existing Ingress resource named web.

## Question 3

Create a new HorizontalPodAutoscaler (HPA) named `apache-server`in the `autoscale`

namespace. This HPA mustītarget the existing Deployment called `apache-server` in the `autoscale` namespace.

Set the HPA to target for 50% CPU usage per Pod.

Configure hpa to have at min 1 Pod and no more than 4 Pods[max]. Also, we have to set the downscale stabilization window to 30 seconds.

## Question 4

Create a new Ingress resource `echo` in `echo-sound` namespace

Exposing Service `echoserver-service` on http://example.org/echo using Service port 8080

The availability of Service `echoserver-service` can be checked

using the following command, which should return 200:

[candidate@cka2025] $ curl -o /dev/null -s -w "%{http_code}\n“ http://example.org/echo

## Question 5

Install and configure a Container Network Interface (CNI) of your choice that meets the specified requirements. Choose one of the following CNI options:

Flannel (v0.26.1)

using the manifest:

[kube-flannel.yml]

(https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml)

Calico (v3.28.2)

using the manifest:

[tigera-operator.yaml]

(https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml)

Ensure the selected CNI is properly installed and configured in the Kubernetes cluster.

## Question 6

Install and configure a Container Network Interface (CNI) of your choice that meets the specified requirements. Choose one of the following CNI options:

Flannel using the manifest →

https://github.com/flannel-io/flannel/releases/download/v0.26.1/kube-flannel.yml

Calico using the manifest →

https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/tigera-operator.yaml

Ensure the selected CNI is properly installed and configured in the Kubernetes cluster.

The CNI you choose must:

Let Pods communicate with each other

Support Network Policy enforcement

Install from manifest files (do not use Helm)

## Question 7

Install Argo CD in cluster:

Add the official Argo CD Helm repository with the name argo.

https://argoproj.github.io/argo-helm

The Argo CD CRDs have already been pre-installed in the cluster.

Generate a helm template of the Argo CD Helm chart

version 7.7.3 for the `argocd` NS and save to /argo-helm.yaml

Configure the chart to not install CRDs.

Install Argo CD using Helm with release name `argocd`

using the same version as above and configuration as used in the template 7.7.3.

Install it in the `argocd` ns and configure it to not install CRDs.

You do not need to configure access to the Argo CD server UI.

## Question 08

Create a new PriorityClass named `high-priority` for user-workloads with a value that is one less than the highest existing user-defined priority class value. 

Patch the existing Deployment `busybox-logger` running in the `priority` namespace to use the high-priority priority class.

Ensure that the `busybox-logger` Deployment rolls out successfully with the new priority class set.

It is expected that Pods from other Deployments running in the priority namespace are evicted.

Do not modify other Deployments running in the priority namespace.

Failure to do so may result in a reduced score.

## Question 09

Reconfigure the existing Deployment `front-end` in namespace `sp-culator` to expose port 80/tcp of the existing container nginx.

Create a new Service named `front-end-svc` exposing the container port 80/tcp.

Configure the new Service to also expose the individual pods via & NodePort

## Question 10

Create a new StorageClass named `low-latency` that uses the existing provisioner [rancher.io/local-path](http://rancher.io/local-path).

Set the VolumeBindingMode to `WaitForFirstConsumer`. (Mandatory or the score will be reduced)

Make the newly created StorageClass (low-latency) the default StorageClass in the cluster.

Do NOT modify any existing Deployments or PersistentVolumeClaims. (If modified, the score will be reduced)

## Question 11

A legacy app needs to be integrated into the Kubernetes built-in logging architecture (i.e. kubectl logs). Adding a streaming co-located container is a good and common way to accomplish this requirement.

**Task**

Update the existing Deployment synergy-deployment, adding a co-located container named sidecar using the busybox:stable image to the existing Pod.

The new co-located container has to run the following command:

`/bin/sh -c "tail -n+1 -f /var/log/synergy-deployment.log"`

Use a Volume mounted at /var/log to make the log file synergy-deployment.log available to the co located container.

Do not modify the specification of the existing container other than adding the required.

Hint: Use a shared volume to expose the log file between the main application container and the sidecar

## Question 12 

Verify the cert-manager application which has been deployed in the cluster.

Create a list of all cert-manager Custom Resource Definitions (CRDs) and save it to ~/resources.yaml.

make sure kubectl's default output format and use kubectl to list CRD's

Do not set an output format.

Failure to do so will result in a reduced score.

Using kubectl, extract the documentation for the subject specification field of the Certificate Custom Resource and save it to ~/subject.yaml.

You may use any output format that kubectl supports.

## Question 13

A WordPress application with 3 replicas in the `relative-fawn` namespace consists of:

cpu 1 memory 2015360ki

Adjust all Pod resource requests as follows:

Divide node resources evenly across all 3 pods.

Give each Pod a fair share of CPU and memory.

Add enough overhead to keep the node stable.

Use the exact same requests for both containers and init containers.

You are not required to change any resource limits.

It may help to temporarily scale the WordPress Deployment to 0 replicas while updating the resource requests.

After updates, confirm:

- WordPress keeps 3 replicas.
- All Pods are running and ready.

## Question 14

A user accidentally deleted the MariaDB Deployment in the mariadb namespace,which was configured with persistent storage.

Your responsibility is to re-establish the Deployment while ensuring data is preserved by reusing the available PersistentVolume.

Task:

A PersistentVolume already exists and is retained for reuse. only one pv exist.

Create a PersistentVolumeClaim (PVC) named `mariadb` in the `mariadb` NS with the spec:

Access mode `ReadWriteOnce` and Storage `250Mi`

Edit the MariaDB Deploy file located at ~/mariadb-deploy.yaml to use PVC created in the previous step.

Apply the updated Deployment file to the cluster.

Ensure the MariaDB Deployment is running and Stable

## Question 15

Prepare a Linux system for Kubernetes. Docker is already installed, but you need to configure it for kubeadm.

Task

Complete these tasks to prepare the system for Kubernetes :

Set up cri-dockerd:

Install the Debian package ~/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb

Debian packages are installed using dpkg.

Enable and start the cri-docker service

Configure these system parameters:

Set net.bridge.bridge-nf-call-iptables to 1

Set net.ipv6.conf.all.forwarding to 1

Set net.ipv4.ip_forward to 1

Set net.netfilter.nf_conntrack max to 131072

## Question 16

We need fix a single-node cluster that got broken during machine migration.

Identify the broken cluster components and investigate what caused to break those components.

The decommissioned cluster used an external etcd server.

Next, fix the configuration of all broken cluster components.

Ensure to restart all necessary services and components for changes to take effect.

Finally, ensure the cluster, single node and all pods are Ready.

## Question 17

We have frontend and backend Deploy in separate NS (frontend and backend). They need to communicate.

Analyze: Inspect the frontend and backend Deployments to understand their communication requirements.

Apply: From the NetworkPolicy YAML files in the ~/netpol folder, choose one to apply. It must:

Allow communication between frontend and backend.

Be as restrictive as possible (least permissive)

Do not delete or change the existing "deny-all" netpol's.

Failure to follow these rules may result in a score reduction or zero.