#### Description ######################################################################################################
#
# Retrieve all service accounts in a cluster used as Cloud workload identities.
#
# Requirement: cluster-admin permissions
#
####

supported_clouds=(
    'azure'
    'gcp'    
)

if [[ $# -ne 1 ]]
then
      echo "[!] Missing argument"
      echo "Usage: $(basename $0) <cloud-solution> (${supported_clouds[@]})"
      exit 0
fi

is_passed_arg_valid='false'

for cloud in ${supported_clouds[@]}
{
    if [[ "$1" == "$cloud" ]]
    then
        is_passed_arg_valid='true'
        break
    fi
}

if [[ "$is_passed_arg_valid" == 'false' ]]
then
      echo "[!] Passed argument invalid"
      echo "$(basename $0) <cloud-solution> (${supported_clouds[@]})"
      exit 0
fi

passed_cloud="$1"
service_accounts_used_as_workload_identities=()
azure_annotation='azure.workload.identity'
gcp_annotation='gcp-service-account'
namespaces=($(kubectl get namespaces -o json | jq -r '.items[] | .metadata | .name' | grep -v kube-system | sort))

for namespace in ${namespaces[@]}
{
    echo "[*] scraping namespace: $namespace"
    service_accounts=($(kubectl get serviceAccounts -o json | jq -r '.items[] | .metadata | .name' | sort))

    for service_account in ${service_accounts[@]}
    {
        if [[ "$passed_cloud" == 'azure' ]]
        then
            is_workload_identity=$(kubectl get serviceAccount "$service_account" -o yaml | grep "$azure_annotation")
        elif [[ "$passed_cloud" == 'gcp' ]]
        then
            is_workload_identity=$(kubectl get serviceAccount "$service_account" -o yaml | grep "$gcp_annotation")
        fi

        if [[ "$is_workload_identity" ]]
        then
            echo "[!] Service account used as workload identity: $namespace/$service_account"
            service_accounts_used_as_workload_identities+=("$namespace/$service_account")
            continue
        fi
    }
}

echo "-----"
echo "The following service accounts are used as workload identities (format: '<namespace>/<serviceAccount-name>'):"
printf '%s\n' "${service_accounts_used_as_workload_identities[@]}" | sort
