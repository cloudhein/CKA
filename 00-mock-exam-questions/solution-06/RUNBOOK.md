## Create a restricted namespace if not created

```bash
kubectl create ns restricted-ns
namespace/restricted-ns created
```

## Restrict the ns with pod security standard(policies)

```bash
kubectl label namespace restricted-ns pod-security.kubernetes.io/enforce=restricted
namespace/restricted-ns labeled
```

## Verify the result

```bash
kubectl get ns restricted-ns -o yaml
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: "2025-09-12T11:03:19Z"
  labels:
    kubernetes.io/metadata.name: restricted-ns
    pod-security.kubernetes.io/enforce: restricted
```

## Verify with nginx pod for restricted policy

```bash
kubectl apply -f pod.yaml -n restricted-ns

Error from server (Forbidden): error when creating "pod.yaml": pods "nginx-pod" is forbidden: violates PodSecurity "restricted:latest"
```

## Notes for Pod Security Standard 

**Pod security restrictions are applied at the namespace level when pods are created.**

**Kubernetes offers a built-in ***Pod Security admission controller*** to enforce the Pod Security Standards.**

There are 3 different policies level to broadly cover the security spectrum.
1. Privileged(Unrestricted policy)
2. Baseline(Minimally restrictive policy which prevents known privilege escalations)
3. Restricted(Heavily restricted policy)

There are 3 different mode to enforce policy:
1. Enforce(Policy violations will cause the pod to be rejected.)
2. Audit(Doesn’t block the pod, but records a violation in the audit logs.)
3. Warn(Shows a warning message to the user (kubectl output), but still allows the pod to run.)

### Pod Security Admission labels for namespaces format

```bash
pod-security.kubernetes.io/<mode>=<policy>

pod-security.kubernetes.io/<MODE>-version: <VERSION>

# Example
pod-security.kubernetes.io/enforce=restricted
pod-security.kubernetes.io/enforce-version: v1.34
```
