# create a pv 
kubectl apply -f pv.yml 
persistentvolume/app-data created

kubectl get pv
NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
app-data   2Gi        RWX            Retain           Available                          <unset>                          4s