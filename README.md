BUILDING THE IMAGE
------------------

Lo primero que necesitamos es construir la imagen sobre la que correran nuestros nodos del cluster. Para ello nos movemos al directorio node y:

Si estamos trabajando en las oficinas de UST necesitamos la imagen con las  variables de entorno que configuran el acceso por el proxy, por lo tanto tenemos que construir la imagen utilizando:

docker build -f DockerfileUST -t hdpust:latest .

Si no estamos trabajando por detrás de ningún proxy:

docker build -t hdp:latest .

RUNNING EXTERNAL POSTGRES
-------------------------

docker run --name postgres -e POSTGRES_PASSWORD=admin -d postgres:9.4

COPY POSTGRESQL SCRIPTS TO POPULATE THE DATABASE
------------------------------------------------

docker cp SetupDatabase.sql postgres:/
docker cp Ambari-DDL-Postgres-CREATE.sql postgres:/

ACCESING THE POSTGRES CONSOLE TO EXECUTE THE SCRIPTS
----------------------------------------------------

docker exec -it postgres bash

psql -U postgres

Run: SetupDatabase con:

\i SetupDatabase.sql
\quit

IMPORTANTE: desconectar de la base de datos y volverse a conectar como ambari!! y entonces:

psql -U ambari

\connect ambari 
\i Ambari-DDL-Postgres-CREATE.sql

List the tables and make sure that ambari is the owner:
\dt                          

RUNNING NODES
-------------

docker run --name=node1 -d -h node1.tcpsi.es --link postgres:postgres hdpnode:latest         


(--- UST ONLY ---)

Necesitamos también configurar el proxy de UST en ambari porque si no no 
será capaz de acceder a Internet, para ello añadimos los siguientes 
parámetros en el script de ar
ranque de Ambari en el fichero 
/var/lib/ambari-server/ambari-env.sh:
-Dhttp.proxyHost=proxy.tcpsi.es 
-Dhttp.proxyPort=8080      

Metemos el proxy en /etc/yum.conf:

proxy=http://proxy.tcpsi.es:8080

Metemos el proxy también en /etc/wgetrc:

https_proxy = https://proxy.tcpsi.es:8080/
http_proxy = http://proxy.tcpsi.es:8080/

(--- UST ONLY ---)

CONFIGURING AND RUNNING THE AMBARI SERVER
-----------------------------------------

Dentro del contenedor:

ambari-server setup

Installer:

1. Customize user account for ambari-server daemon [y/n](n)? n

2. Checking JDK...
[1] Oracle JDK 1.8 + Java Cryptography Extension (JCE) Policy Files 8
[2] Oracle JDK 1.7 + Java Cryptography Extension (JCE) Policy Files 7
[3] Custom JDK

Seleccionar 3 e introducir manualmente el jdk basepath (/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.151-5.b12.el7_4.x86_64/jre/)

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
(Resto de valores por defecto)

ambari-server start

Mapear el host de docker en el /etc/hosts de la máquina en la que vamos a acceder a la interfaz de ambari


Comprobar que el servidor funciona accediendo a: http://node1.tcpsi.es:8080 desde el navegador


INSTALACIÓN ATLAS
-----------------

cd /usr/hdp/current/atlas-server/server/webapp
cp atlas.war atlas
cd atlas
jar -xvf atlas.war