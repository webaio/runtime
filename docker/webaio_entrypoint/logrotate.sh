#!/bin/bash

chmod +x /webaio/docker/webaio_entrypoint/logrotate.sh

filename="/var/log/nginx/access.log"

while true
do
    if [ -f "${filename}" ] && [ -s "${filename}" ]
    then
            timestamp=$(date +%s)
            echo "Renaming ${filename} ${filename}.${timestamp}.log"
            mv "${filename}" "${filename}.${timestamp}.log"
            kill -USR1 `cat /var/run/nginx.pid`
            sleep 5
            mv "${filename}.${timestamp}.log" "/var/log/requests/access.${timestamp}.log"
    fi

    sleep 30
done