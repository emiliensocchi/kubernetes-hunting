#### Description ######################################################################################################
# 
# Retrieves all Routes paths with their respective host in an OpenShift cluster.
#
# Note: routes are specific to OpenShift and are usually used instead of ingresses
# Requirement: cluster-admin permissions
#
####

all_routes_paths=()
namespaces=($(kubectl get namespaces -o json | jq -r '.items[] | .metadata | .name' | sort))

for namespace in ${namespaces[@]}
{
    echo "[*] scraping namespace: $namespace"
    routes=($(kubectl get routes --namespace "$namespace" -o json | jq -r '.items[] | .metadata | .name' | sort))

    for route in ${routes[@]}
    {
        host=$(kubectl get route --namespace "$namespace" "$route" -o json | jq -r '.spec | .host')
        path=$(kubectl get route --namespace "$namespace" "$route" -o json | jq -r '.spec | .path')

        all_routes_paths+=("https://${host}${path}")
    }
}

echo "-----"
echo "The cluster exposes internal services via the following Route paths:"
printf '%s\n' "${all_routes_paths[@]}" | sort
