#### Description ######################################################################################################
# 
# Retrieves all Traefik routes in a cluster.
#
# Requirement: cluster-admin permissions
#
####

routes=$(kubectl describe ingressroutes.traefik.containo.us -A | grep Match | sed "s/.*Host(\`//"g | sed "s/\`).*PathPrefix(\`//" | sed "s/\`)//" | sort | uniq)
printf '%s\n' "${routes[@]}"
