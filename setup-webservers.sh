#!/bin/bash
docker build -t netsil/apache-app webservers/apache 
docker build -t netsil/haproxy-app webservers/haproxy
