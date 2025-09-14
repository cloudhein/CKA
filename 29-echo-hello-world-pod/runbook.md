# create a pod that echo “hello world” and then exists
kubectl run hello-world-pod --image=busybox --restart=Never --rm -it --command -- /bin/sh -c 'echo hello world'
hello world
pod "hello-world-pod" deleted