## Setup Configuration

### Setup for certmanger configuration

- A **fake cert-manager namespace**
- Two CRDs (`Certificate`, `Issuer`) with minimal schema including a `subject` field on `Certificate` spec
- This setup meets the exam question conditions without a full cert-manager install

### Generate so-called-cert-manger 

```bash
kubectl apply -f so-called-cert-manager.yaml 

namespace/cert-manager created
customresourcedefinition.apiextensions.k8s.io/certificates.cert-manager.io created
customresourcedefinition.apiextensions.k8s.io/issuers.cert-manager.io created
```

## Solution Setup

### Create a list of all cert-manager Custom Resource Definitions (CRDs) and save it to ~/resources.yaml

```bash
kubectl get crds | grep cert-manager > ./resources.yaml
```

### Using kubectl, extract the documentation for the subject specification field of the Certificate Custom Resource and save it to ~/subject.yaml

```bash
kubectl explain certificates.spec.subject > ./subject.yaml
```