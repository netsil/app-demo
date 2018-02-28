#!/bin/bash
webserver=$1
if [ "$webserver" = "apache" ] ; then
elif [ "$webserver" = "haproxy" ] ; then
elif [ "$webserver" = "web-app" ] ; then
    python simple-http-server.py
else 
    echo "Error! Webserver $webserver not recognized! Please specify 'apache', 'haproxy', or 'web-app'"
    exit 1
fi
