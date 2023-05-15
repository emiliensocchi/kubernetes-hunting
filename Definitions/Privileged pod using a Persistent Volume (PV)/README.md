
# Privileged pod using a persistent volume

Sometimes, the hostPath volume mounted in a privileged pod needs to be provisioned statically via a Persistent Volume (PV). 

This is for example the case with <u>OpenShift</u>.


## Usage

### Deploy via kubectl

```shell
kubectl apply -f pv.yaml && kubectl apply -f pvc.yaml && kubectl apply -f pod-privileged-with.pv.yaml
```


## Credits
https://docs.openshift.com/container-platform/4.2/storage/persistent_storage/persistent-storage-hostpath.html
