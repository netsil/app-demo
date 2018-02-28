#!/bin/bash
sudo docker build -t netsil/apache-app webservers/apache 
sudo docker build -t netsil/haproxy-app webservers/haproxy
