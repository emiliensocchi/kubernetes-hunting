#### Description ######################################################################################################
# 
# Retrieves all Ingress paths with their respective host in a cluster.
#
# Requirement: cluster-admin permissions
#
####

all_ingress_paths=()
namespaces=($(kubectl get namespaces -o json | jq -r '.items[] | .metadata | .name' | sort))

for namespace in ${namespaces[@]}
{
    echo "[*] scraping namespace: $namespace"
    ingresses=($(kubectl get ingresses.networking.k8s.io --namespace "$namespace" -o json | jq -r '.items[] | .metadata | .name' | sort))

    for ingress in ${ingresses[@]}
    {
        rules="$(kubectl get ingresses.networking.k8s.io --namespace "$namespace" "$ingress" -o json | jq -r '.spec | .rules[]')"
        host=$(echo "$rules" | jq -r '.host')
        paths=($(echo "$rules" | jq -r '.http | .paths[] | .path'))

        if [[ "$host" == 'null' ]]; then host='*'; fi

        if [[ "${paths[0]}" == 'null' ]]
        then
            all_ingress_paths+=("https://${host}")
        else
            for path in ${paths[@]}
            {
                all_ingress_paths+=("https://${host}${path}")
            }
        fi
    }
}

echo "-----"
echo "The cluster exposes internal services via the following Ingress paths:"
printf '%s\n' "${all_ingress_paths[@]}" | sort | uniq
