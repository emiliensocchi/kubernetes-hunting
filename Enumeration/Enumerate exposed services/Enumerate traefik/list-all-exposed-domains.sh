#### Description ######################################################################################################
# 
# Retrieves all domains and subdomains exposed to the outside world by a cluster.
#
# Note: Domains can be easily resolved as follows:
#       for domain in $(cat domains.list); do nslookup "$domain" | grep -A1 "$domain"; done | tee resolved-domains.list
#
# Requirement: cluster-admin permissions
#
####

domains=$(kubectl describe ingressroutes.traefik.containo.us -A | grep Match | sed "s/.*Host(\`//"g | sed "s/\`).*PathPrefix(\`//" | sed "s/\`)//" | grep -v Match | sed "s/\/.*//" | sort | uniq)
printf '%s\n' "${domains[@]}"
