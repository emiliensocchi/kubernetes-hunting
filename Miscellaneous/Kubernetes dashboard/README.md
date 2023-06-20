# Kubernetes dashboard

Deploy the Kubernetes dashboard to an existing cluster.


## Prerequisites

- a service account with cluster-admin permissions

## Usage

### Deploy the dashboard

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
```

### Access the dashboard

```shell
kubectl proxy
```
```shell
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

OR

```shell
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8080:443
```
```shell
https://localhost:8080
```

### Get an access token for the provided service account

```shell
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/<name_of_service_account> -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
```

### Create a dedicated service account with cluster-admin permissions (needed if no proper service account but only a user through an external Identity provider is provided)

```shell
kubectl apply -f admin-sa.yaml
```

## Clean up

```shell
kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml && kubectl delete -f admin-sa.yaml
```

## Credits
https://github.com/kubernetes/dashboard/blob/master/README.md
