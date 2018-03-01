#!/bin/bash
while true ; do
    echo "Requesting myapache.html..."
    curl http://${APACHE_HOST}:${APACHE_PORT}/myapache.html
    echo "Requesting apacheweb.html..."
    curl http://${APACHE_HOST}:${APACHE_PORT}/apacheweb.html
    sleep 3
done
