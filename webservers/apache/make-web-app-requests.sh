#!/bin/bash
while true ; do
    curl http://${WEB_APP_HOST}:${WEB_APP_SERVER_PORT}/mobile
    curl http://${WEB_APP_HOST}:${WEB_APP_SERVER_PORT}/desktop
    curl http://${WEB_APP_HOST}:${WEB_APP_SERVER_PORT}/laptop
    curl http://${WEB_APP_HOST}:${WEB_APP_SERVER_PORT}/netbook
    sleep 5
done
