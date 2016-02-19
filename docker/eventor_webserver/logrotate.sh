#!/bin/bash
chmod +x /webaio/docker/webaio_eventor_webserver/logrotate.sh

filename="/var/log/nginx/access.log"

while true
do
    if [ -f "${filename}" ] && [ -s "${filename}" ]
    then
            timestamp=$(date +%s)
            echo "Renaming ${filename} ${filename}.${timestamp}.log"
            mv "${filename}" "${filename}.${timestamp}.log"
            if [ -f /var/run/nginx.pid ]; then
                kill -USR1 `cat /var/run/nginx.pid`
            fi
            sleep 1
            mv "${filename}.${timestamp}.log" "/var/log/requests/access.${timestamp}.log"
    fi

    sleep 30
done