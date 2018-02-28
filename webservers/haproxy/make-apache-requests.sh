#!/bin/bash
while true ; do
    curl http://${APACHE_HOST}:${APACHE_PORT}/myapache.html
    curl http://${APACHE_HOST}:${APACHE_PORT}/apacheweb.html
    sleep 3
done
