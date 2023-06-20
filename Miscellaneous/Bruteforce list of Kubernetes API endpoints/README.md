# Bruteforce list of Kubernetes API endpoints

Collection of endpoints in the Kubernetes API used for bruteforcing with anonymous accounts.

## Generate list

```shell
curl -sk https://raw.githubusercontent.com/kubernetes/kubernetes/master/api/openapi-spec/swagger.json | jq '.paths | keys' | sed "s/  \"//" | sed "s|\"[,]*||" | tail -n +2 | head -n -1 | sed "s/{namespace}/default/" | grep -v '{'
```
