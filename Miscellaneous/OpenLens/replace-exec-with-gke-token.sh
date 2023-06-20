#### Description ######################################################################################################
#
# Replaces the exec plugin with a GKE access token in the kubeconfig file of the running user.
#
####

KUBE_CONFIG="$HOME/.kube/config"
token=$(gke-gcloud-auth-plugin | jq -r '."status"."token"')

if [[ -z "$token" ]]
then
    echo "[!] You are not logged in with gcloud"
    echo "gcloud container clusters get-credentials <cluster_name> --region <region_name> --project <project_name>"
    exit 0
fi

if [[ -z "$(cat $KUBE_CONFIG | grep exec)" ]]
then
    # Token is being refreshed
    sed -i "s/token.*/token: $token/g" "$KUBE_CONFIG"
else
    # Token is being populated for the first time
    sed -i '/exec/,$d' "$KUBE_CONFIG"
    sed -i '$a\    token: '"$token"'' "$KUBE_CONFIG"
fi

# Skip mTLS verification
sed -i "s/certificate-authority-data.*/insecure-skip-tls-verify: true/g" "$KUBE_CONFIG"

echo "Exec plugin successfully replaced with access token in '$KUBE_CONFIG'"
