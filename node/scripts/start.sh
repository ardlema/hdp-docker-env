#!/bin/bash
touch /etc/prueba.txt
echo $(head -1 /etc/hosts | cut -f1) $HOST_NAME >> /etc/hosts
tail -f /dev/null
exec "$@";