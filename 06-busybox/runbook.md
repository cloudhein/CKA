# run the pods with env command and save the output to envpod 
kubectl run busybox --image=busybox --restart=Never --rm -it -- env > envpod.yml