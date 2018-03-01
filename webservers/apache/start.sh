#!/bin/bash
cp /usr/local/apache2/htdocs/index.html /usr/local/apache2/htdocs/myapache.html
cp /usr/local/apache2/htdocs/index.html /usr/local/apache2/htdocs/apacheweb.html
httpd
/root/make-web-app-requests.sh
