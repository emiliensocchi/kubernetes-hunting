# OpenShift

## Obtain an access token from the OpenShift OAuth API using user credentials

`Background`: OpenShift does not allow using a username and password directly in a kubeconfig file and the use of an access token is required by default.

```shell
curl -u "<username>:<password>" -kv -H "X-CSRF-Token: xxx" 'https://oauth-openshift.apps.<cluster-name>.<domain>/oauth/authorize?client_id=openshift-challenging-client&response_type=token'
```

The access token should be appended as a URL parameter in the Location header returned by the server.