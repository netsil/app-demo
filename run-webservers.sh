#!/bin/bash
webserver=$1
if [ "$webserver" = "apache" ] ; then
    APACHE_PORT=${APACHE_PORT:-8081}
    WEB_APP_SERVER_PORT=${WEB_APP_SERVER_PORT:-8080}
    if [ -z "${WEB_APP_HOST}" ] ; then
        echo "Error! You must specify WEB_APP_HOST"
        exit 1
    fi
    sudo docker run -td \
            --name apache-app \
            -e WEB_APP_HOST=${WEB_APP_HOST} \
            -e WEB_APP_SERVER_PORT=${WEB_APP_SERVER_PORT} \
            -p ${APACHE_PORT}:80 \
            netsil/apache-app
     
elif [ "$webserver" = "haproxy" ] ; then
    HAPROXY_PORT=${HAPROXY_PORT:-8082}
    APACHE_PORT=${APACHE_PORT:-8081}
    if [ -z "${APACHE_HOST}" ] ; then
        echo "Error! You must specify APACHE_HOST"
        exit 1
    fi
    sudo docker run -td \
            --name haproxy-app \
            -e APACHE_HOST=${APACHE_HOST} \
            -e APACHE_PORT=${APACHE_PORT} \
            -p ${HAPROXY_PORT}:80 \
            netsil/haproxy-app
elif [ "$webserver" = "web-app" ] ; then
    export WEB_APP_SERVER_PORT=${WEB_APP_SERVER_PORT:-8080}
    python simple-http-server.py
else 
    echo "Error! Webserver $webserver not recognized! Please specify 'apache', 'haproxy', or 'web-app'"
    exit 1
fi
