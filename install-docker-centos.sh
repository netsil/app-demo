#!/bin/bash
sudo yum install -y yum-utils \
     device-mapper-persistent-data \
     lvm2

sudo yum-config-manager \
     --add-repo \
     https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce-17.12.0.ce

sudo systemctl start docker && sudo systemctl enable docker
