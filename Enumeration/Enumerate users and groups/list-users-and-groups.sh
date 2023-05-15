#### Description ######################################################################################################
#
# Retrieves all users and groups in a cluster.
#
# Note: users and groups are subjects that are understood as such by Kubernetes, but managed by an external IDaaS solution.
#       There is no way to map out group membership from Kubernetes itself, as the mapping is external to the infrastructure (i.e. in the IDaaS solution).
#
# Requirement: cluster-admin permissions
#
####

# Retrieves all users and groups figuring as subjects in a ClusterRoleBinding
crb_groups=$(kubectl get clusterrolebindings -o json | jq -r '.items[] | .subjects[]? | select(.kind=="Group") | .name' | sort | uniq)
crb_users=$(kubectl get clusterrolebindings -o json | jq -r '.items[] | .subjects[]? | select(.kind=="User") | .name' | sort | uniq)

# Retrieves all users and groups figuring as subjects in a roleBinding
rb_groups=$(kubectl get rolebindings -o json -A | jq -r '.items[] | .subjects[]? | select(.kind=="Group") | .name' | sort | uniq)
rb_users=$(kubectl get rolebindings -A -o json | jq -r '.items[] | .subjects[]? | select(.kind=="User") | .name' | sort | uniq)

# Merge (might have duplicates)
all_groups=( $(echo ${crb_groups[@]}) $(echo ${rb_groups[@]}) )
all_users=( $(echo ${crb_users[@]}) $(echo ${rb_users[@]}) )

echo "# THE GROUPS IN THE CLUSTER ARE:"
printf '%s\n' "${all_groups[@]}" | sort -u

echo ""
echo "# THE USERS IN THE CLUSTER ARE:"
printf '%s\n' "${all_users[@]}" | sort -u
