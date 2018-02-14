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
NETSIL_AOC_HOST=<Your-aoc-host> NETSIL_ORGANIZATION_ID=<Your-org-id> ./manifests/collector-db.sh
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
grant all on appdb.* to '<your-user>' identified by '<your-password>';
```

# Web App
## Prerequisites
- A Centos 7 VM

## Setup the collectors
As a root user, run the script below, making sure to fill in your AOC host and organization ID:
```
NETSIL_AOC_HOST=<Your-aoc-host> NETSIL_ORGANIZATION_ID=<Your-org-id> ./manifests/collector-web.sh
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
