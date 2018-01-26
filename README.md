# Description

This project allows to deploy a HortonWorks Data Platform locally using docker images.

_**Important: I've deployed an HDP cluster using this approach as part of my work for UST Global Inc. for development purposes but is not recommended to use this in a production environment**_

# Building the images

The images have not been pushed to any dockerhub repo so you should build them by yourself.

To do so, go to the docker folder and execute the following command:

```
docker build -t hdp:latest .
```

If you are working behind an http proxy please build your image using:

```
docker build -f DockerfileProxy -t hdp:latest --build-arg HTTPPROXY=<your-proxy-host>:<your-proxy-port> --build-arg HTTPSPROXY=<your-proxy-host>:<your-proxy-port> .
```

# Running the cluster

## Run an external PostgreSQL database

The Hortonworks Data Platform needs a database.

We recommend to run a PostgreSQL database running also in a docker container. To start this container execute the following command:

```
docker run --name postgres -e POSTGRES_PASSWORD=admin -d postgres:9.4
```

## Populating the database

Before installing the platform we need to create the database schema for Ambari.

To do so you need to copy the scripts included in the scripts folder to the docker containers by going to the root folder of the project and executing the following commands:

```
docker cp scripts/SetupDatabase.sql postgres:/
docker cp scripts/Ambari-DDL-Postgres-CREATE.sql postgres:/
```

Now go inside the container and execute the scripts by executing the following commands:

```
docker exec -it postgres bash
psql -U postgres
\i SetupDatabase.sql
\quit
psql -U ambari
\connect ambari 
\i Ambari-DDL-Postgres-CREATE.sql

```

Finally list the tables and make sure that ambari is the owner of all of them:

```
\dt
```

Exit the psql shell and exit the container as well:
     
```
\q
exit
```

## Starting a cluster node

To start the first cluster node execute the following:

docker run --name=node1 -d -h node1.ust.com --link postgres:postgres hdp:latest         

Again if you are working behind a proxy you should have a look at the lines below if not skip to the next section

To configure your proxy go inside the container by executing:

docker exec -it node1 bash

And include in the java parameters of the Ambari server script (/var/lib/ambari-server/ambari-env.sh) the following ones:

```
-Dhttp.proxyHost=<your-proxy-host>
-Dhttp.proxyPort=<your-proxy-port>
```

We also add the proxy in the /etc/yum.conf file by adding the following line:

```
proxy=http://<your-proxy-host>:<your-proxy-port>
```

And finally we add the proxy within the /etc/wgetrc by adding:

```
https_proxy = https://<your-proxy-host>:<your-proxy-port>/
http_proxy = http://<your-proxy-host>:<your-proxy-port>/
```

## Setting up the Ambari server

Inside the node1 container execute:

```
ambari-server setup
```

And configure Ambari server with the following parameters:

Installer:

```
1. Customize user account for ambari-server daemon [y/n](n)? n

2. Checking JDK...
[1] Oracle JDK 1.8 + Java Cryptography Extension (JCE) Policy Files 8
[2] Oracle JDK 1.7 + Java Cryptography Extension (JCE) Policy Files 7
[3] Custom JDK

Select 3 and introduce the java base path (/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.el7_4.x86_64/jre/)

3. Enter advanced database configuration [y/n](n)? y

Choose one of the following options:
[1] - PostgreSQL (Embedded)
[2] - Oracle
[3] - MySQL / MariaDB
[4] - PostgreSQL
[5] - Microsoft SQL Server (Tech Preview)
[6] - SQL Anywhere
[7] - BDB
==============================================================================
Enter choice (1): 4

Hostname (localhost): postgres
(The rest of the values by default)
```

## Starting the Ambari server

Before start the server and inside the container start the ntpd daemons by running:

```
ntpd
```

Then you can start the ambari server by running:

```
ambari-server start
```

Map the host of the container in your local box by finding its IP address and access to the Ambari UI by typing the following on your preferred browser:

```
http://node1.ust.com:8080
```

Following the instructions on the Ambari UI to install your cluster


## Adding more nodes to the cluster

To add more nodes to your cluster you just need to start more docker containers by executing for instance:

```
docker run --name=node1 -d -h node2.ust.com --link postgres:postgres hdp:latest 
```

**Important: if you add more nodes to the cluster you need to also add the node to the /etc/hosts file of all the containers!!**

