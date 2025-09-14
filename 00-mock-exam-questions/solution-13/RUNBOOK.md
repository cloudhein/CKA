## Deploy the application 

```bash
kubectl apply -f deployment.yaml 
deployment.apps/nginx-deployment created
service/web-service created
```

## Check the deployed application 

```bash
kubectl get all
NAME                                  READY   STATUS    RESTARTS   AGE
pod/nginx-deployment-96b9d695-frrkw   1/1     Running   0          79s

NAME                  TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
service/kubernetes    ClusterIP   10.133.0.1    <none>        443/TCP   2d
service/web-service   ClusterIP   10.133.5.43   <none>        80/TCP    79s

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   1/1     1            1           79s

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-96b9d695   1         1         1       79s
```

## Install traefik gateway api with helm 

```bash
helm install traefik --namespace=traefik --create-namespace traefik/traefik --set providers.kubernetesGateway.enabled=true
```

## Install gateway provider (traefik) 

```bash
kubectl apply -f gatewayclass.yaml 
gatewayclass.gateway.networking.k8s.io/example-gw-class created
```

```bash
kubectl get gatewayclass
NAME               CONTROLLER                      ACCEPTED   AGE
example-gw-class   traefik.io/gateway-controller   True       6s
```

## Verify the traefik api resources are successfully installed or not 

```bash
kubectl get all -n traefik
NAME                          READY   STATUS    RESTARTS   AGE
pod/traefik-c84d5f764-b2b8z   1/1     Running   0          75m

NAME              TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE
service/traefik   LoadBalancer   10.133.188.5   172.18.255.180   80:32699/TCP,443:30708/TCP   75m

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/traefik   1/1     1            1           75m

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/traefik-c84d5f764   1         1         1       75m
nandahein@Nanda-Ubuntu:~/pov-kubernetes/CKA/00-mock-exam-questions/solution-13$ 
```

## Install gateway 

```bash
kubectl apply -f gateway.yaml 
gateway.gateway.networking.k8s.io/example-gateway created
```

### Verify gateway installation
```bash
kubectl get gateway
NAME              CLASS              ADDRESS          PROGRAMMED   AGE
example-gateway   example-gw-class   172.18.255.180   True         37m
```

## Install http route

```bash
kubectl apply -f http-route.yaml 
httproute.gateway.networking.k8s.io/example-httproute created
```

#### Verify the output
```bash
kubectl get httproute
NAME                HOSTNAMES             AGE
example-httproute   ["web.example.com"]   17s
```

## Call the loadbalancer endpoint to check the gateway api config is successfully worked or not

```bash
curl http:///172.18.255.180 -H "Host: web.example.com"
```