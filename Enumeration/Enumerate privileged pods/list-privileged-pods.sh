#### Description ######################################################################################################
#
# Retrieves all privileged pods in a cluster.
#
# Note: does not detect pods using the default CAP_NET_RAW Linux capability, as this is default in Kubernetes
#
# Requirement: cluster-admin permissions
#
####

privileged_pods=()
privileged_values=(
    'hostPID'
    'hostIPC'
    'hostNetwork'
    'privileged'
    'allowPrivilegeEscalation'
)
namespaces=($(kubectl get namespaces -o json | jq -r '.items[] | .metadata | .name' | grep -v kube-system | sort))

for namespace in ${namespaces[@]}
{
    echo "[*] scraping namespace: $namespace"
    pods=($(kubectl get pods --namespace "$namespace" -o json | jq -r '.items[] | .metadata | .name' | sort))

    for pod in ${pods[@]}
    {
        # Checks Linux capabilities
        is_privileged=$(kubectl get pod "$pod" --namespace "$namespace" -o yaml | grep capabilities -A 3 | grep add)

        if [[ "$is_privileged" ]]
        then
            echo "[!] Pod running privileged container: $namespace/$pod"
            privileged_pods+=("$namespace/$pod")
            continue
        fi

        # Checks hostPath volumes
        is_privileged=$(kubectl get pod "$pod" --namespace "$namespace" -o yaml | grep hostPath)

        if [[ "$is_privileged" ]]
        then
            echo "[!] Pod running privileged container: $namespace/$pod"
            privileged_pods+=("$namespace/$pod")
            continue
        fi

        # Checks other dangerous security contexts
        for privileged_value in ${privileged_values[@]}
        {
            is_privileged=$(kubectl get pod "$pod" --namespace "$namespace" -o yaml | grep "$privileged_value" | sed "s/.*: //")

            if [[ "$is_privileged" == "true" ]]
            then
                echo "[!] Pod running privileged container: $namespace/$pod"
                privileged_pods+=("$namespace/$pod")
                break
            fi
        }
    }
}

echo "-----"
echo "The following pods are running at least one privileged container (format: '<namespace>/<pod-name>'):"
printf '%s\n' "${privileged_pods[@]}" | sort
