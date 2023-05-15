#### Description ######################################################################################################
#
# Retrieves all pods currently mounting the Secret with the inputted name in the inputted namespace.
#
# Note: Secrets always reside in a namespace and a pod cannot mount a Secret located in another namespace.
#
# Requirement: cluster-admin permissions
#
####

read -p 'Secret: ' secret_to_find
read -p 'Namespace: ' namespace
pods_using_secret=()
pods=($(kubectl get pods --namespace "$namespace" -o json | jq -r '.items[] | .metadata | .name' | sort))
c=1

for pod in ${pods[@]}
{
    secrets=($(kubectl describe pod "$pod" --namespace "$namespace" | grep SecretName | sed "s/.*[[:space:]]//"))

    for secret in ${secrets[@]}
    {
        if [[ "$secret" == "$secret_to_find" ]];
        then
            pods_using_secret+=("$pod")
        fi
    }
}

if [[ ${#pods_using_secret[@]} -gt 0 ]];
then
    echo ""
    echo "The '$secret_to_find' Secret is currently mounted by the following pods:"
    printf '%s\n' "${pods_using_secret[@]}" | sort -u

else
    echo ""
    echo "The '$secret_to_find' Secret is not mounted by any pod currently."
fi
