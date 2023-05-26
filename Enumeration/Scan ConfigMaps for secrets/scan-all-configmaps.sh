#### Description ######################################################################################################
# 
# Retrieves all configMaps in a cluster and scans each of them for recognizable secrets using gitleaks.
#
# Note: this script is idempotent, so old configmaps that might have been gathered previously are delete upon startup
#
# Requirement: cluster-admin permissions
#
####

dirname_all_configmaps='all_configmaps'
path_to_all_configmaps="$(pwd)/$dirname_all_configmaps"
namespaces=($(kubectl get namespaces -o json | jq -r '.items[] | .metadata | .name' | sort))

rm -rf "$path_to_all_configmaps"
mkdir -p "$path_to_all_configmaps"

for namespace in ${namespaces[@]}
{
    echo "[*] scraping namespace: $namespace"
    mkdir -p "$path_to_all_configmaps/$namespace"
    configmaps=($(kubectl get configmaps --namespace "$namespace" -o json | jq -r '.items[] | .metadata | .name' | sort))

    for configmap in ${configmaps[@]}
    {
        echo "[**] exporting configmap: $configmap"
        kubectl describe configmap "$configmap" --namespace "$namespace" > "${path_to_all_configmaps}/$namespace/${configmap}"
    }
    
    echo ""
}

echo "[*] Scanning configmaps for secrets"
docker run --rm -v "$(pwd):/gitleaks" ghcr.io/gitleaks/gitleaks:latest detect -v --source="/gitleaks/$dirname_all_configmaps" --no-git --no-banner --config="/gitleaks/extended-gitleaks.toml"
