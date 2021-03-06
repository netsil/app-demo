# App Demo
This app demo sets up a simulation app that consists of
- A mobile app, deployed on k8s
- A DB app, deployed on a VM
- Two web apps, deployed on VMs

The web apps make requests to the DB as well as to the mobile app

In addition, you will need to set up the collectors for each app

See instructions below

# Mobile App
## Prerequisites
- A k8s cluster, 3 nodes, at least 2vCPU/4GB RAM each

You must also have `kubectl` access to the k8s cluster in question

## Run the collectors
First, fill in your AOC host and organization ID in `manifests/collector-app.yaml` 

Now, to set up the collectors, run the commands 
```
kubectl create ns netsil
kubectl create -f manifests/collector-app.yaml
```

## Run the app
To set up the mobile app, run the command 
```
kubectl create -f mobile-app.yaml
```

The mobile app has a front-end service exposed on port 30001.
Kubernetes will proxy the front-end service 


# DB App
## Prerequisites
- A Centos 7 VM

## Run the collectors
As a root user, run the script below, making sure to fill in your AOC host and organization ID:
```
NETSIL_SP_HOST=<Your-aoc-host> NETSIL_ORGANIZATION_ID=<Your-org-id> NETSIL_COLLECTORS_VERSION=<collector-version> ./manifests/collector-db.sh
```

## Setup the db
First, run the script below to install mysql
```
./install-mysql.sh
```

Next, you will have to configure mysql so it can be accessed from non-localhost addresses. 
Usually this consists of editing `/etc/my.cnf` to make sure the `bind-address` is set to all addresses:
```
bind-address    = 0.0.0.0
```

Finally, restart and enable mysqld:
```
sudo systemctl start mysqld && sudo systemctl enable mysqld
```

You will also have to initialize a database and create a user.
Login to the database with
```
mysql -u root
```
and run the following commands

```
create database appdb;
grant all on appdb.* to '<your-user>'@'%' identified by '<your-password>';
```

# Web App
## Prerequisites
- A Centos 7 VM

## Setup the collectors
As a root user, run the script below, making sure to fill in your AOC host and organization ID:
```
NETSIL_SP_HOST=<Your-aoc-host> NETSIL_ORGANIZATION_ID=<Your-org-id> NETSIL_COLLECTORS_VERSION=<collector-version> ./manifests/collector-web.sh
```

## Setup the web app
First, run the script below
```
./setup-web.sh
```

## Run the web app
To run the web app, you must first export some variables:
```
export APP_FE_HOST=<K8s-internal-address> \
export DB_HOST=<DB-VM-internal-address> \
export DB_USER=<your-app-user> \
export DB_PASS=<your-app-password>
```

For the `APP_FE_HOST`, you can use the address of any of your k8s worker nodes.
K8s will proxy the requests to the front-end service from the node port on any of those nodes

Next, run the script

```
./run-web.sh
```

This will run the web app in the foreground of your shell.
After this, you should start seeing connections in your AOC map

You can optionally stop mysql traffic from one of the web apps if you run the `run-web.sh` script with the `STOP_MYSQL=yes` variable.

# Web-servers 
We also provide two webserver containers which talk to each other and the web app

## Prerequisites
- Docker is installed on the VM(s) where you're running the webservers 
- Make sure that communication between the webservers are allowed through the firewall

You may use the provided `./install-docker-centos.sh` script to install docker. 

This script has been tested on Centos 7.

## Architecture
A container running haproxy will make requests to another container running apache.

The apache container will then make requests to the vm running the web app.

For a more visually pleasing topology, you may wish to run the haproxy and apache containers on different vms so there are more hosts.

## Setup the collectors
If you are running the webserver containers on their own vms, and not reusing the ones for the web app or db, you will want to install collectors on those vms.

To do so, run the script below as a root user, making sure to fill in your AOC host and organization ID:
```
NETSIL_SP_HOST=<Your-aoc-host> NETSIL_ORGANIZATION_ID=<Your-org-id> NETSIL_COLLECTORS_VERSION=<collector-version> ./manifests/collector-webservers.sh
```

## Setup the webservers
Run the script below to build the containers for the webservers. 

This script should be run on the vms where you're running the webservers:
```
./setup-webservers.sh
```

## Run a webserver on the web app vm
Since we have to make requests from the apache container to the web app, we must have a server running on the web app vm.

A basic python HTTP server is provided for this purpose. 

Before running the python webserver, you may specify a port number that it will listen on
(This port number is 8080 by default):

```
export WEB_APP_SERVER_PORT=<port-number>
```
The following command will start the python http server in the foreground:
```
./run-webservers.sh web-app
``` 

## Run the webservers
Before running the apache webserver, you must first give it the location of the web app vm and the port number of the web app server (8080 by default) and the port number of the apache server itself (8081 by default):
```
export WEB_APP_HOST=<internal-address-of-web-app-vm>  \
export WEB_APP_SERVER_PORT=<port-number> \
export APACHE_PORT=<port-number>
```
Now, you can run the apache webserver with the following command
```
./run-webservers.sh apache
```
This will run a docker container in the background with container name `apache-app`

Next, before running the haproxy webserver, you must first give it the host and port (8081 by default) of the apache server. You can also specify a port for haproxy to listen on (8082 by default), though in this current setup, no applications talk to haproxy:
```
export APACHE_HOST=<address-of-vm-where-apache-container-is-running> \
export APACHE_PORT=<port-number> \
export HAPROXY_PORT=<port-number>
```

Now, you can run the haproxy webserver with the following command
```
./run-webservers.sh haproxy
```
This will run a docker container in the background with container name `haproxy-app`

## Tips
* If you run `docker logs -f haproxy-app`, this will print the logs of the haproxy app container, and you should be able to see success logs from its requests to the apache app
* Similarly, the output of the web-app python webserver should have success logs from requests made by the apache app
