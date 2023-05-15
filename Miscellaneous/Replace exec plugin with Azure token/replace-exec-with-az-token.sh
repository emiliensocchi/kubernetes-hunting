#### Description ######################################################################################################
#
# Replaces the exec plugin with an Azure access token in the kubeconfig file of the running user.
#
####

KUBE_CONFIG="$HOME/.kube/config"
token="$(kubelogin get-token --login azurecli --server-id 6dae42f8-4368-4678-94ff-3960e28e3630  | jq -r '.status | .token')"

if [[ -z "$token" ]]
then
    echo "[!] You are not logged in with az cli"
    echo "az aks get-credentials --subscription-id <sub_id> --resource-group <rg_name> --name <cluster_name>"
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

echo "Exec plugin successfully replaced with access token in '$KUBE_CONFIG'"
