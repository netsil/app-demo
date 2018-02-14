#!/bin/bash
./install-mysql.sh

sudo yum -y install python-pip python-wheel
sudo pip install locustio
