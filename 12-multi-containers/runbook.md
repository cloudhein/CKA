# create manifest file for multi-container-pods
kubectl run pod multi-pods --image=nginx --dry-run=client -o yaml > multi-containers.yml

# modify the manifest files and deploy the mult-container-pods
kubectl apply -f multi-containers.yml

# list the multi-container-pods 
kubectl get pods
NAME                  READY   STATUS    RESTARTS   AGE
multi-container-pod   3/3     Running   0          2m39s

# port-forward the nginx pod in multi-container-pods
kubectl port-forward pod/multi-container-pod 8081:80
Forwarding from 127.0.0.1:8081 -> 80
Forwarding from [::1]:8081 -> 80

# call the nginx pod
while true; do curl localhost:8081 ; sleep 3; done
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

# port-forward the http-echo pod in multi-container-pods
kubectl port-forward pod/multi-container-pod 8080:8080
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080

# call the http-echo pod
while true; do curl localhost:8080 ; sleep 3; done
welcome to hc
welcome to hc