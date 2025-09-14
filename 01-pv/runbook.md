# create pv with manifest file
kubectl apply -f pv.yml

# check the created pv
kubectl get pv
NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
app-data   1Gi        ROX            Retain           Available                          <unset>                          67s