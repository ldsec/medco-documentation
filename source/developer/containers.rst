Description of a Deployed Node
==============================
TBD
This page describes the deployment of a MedCo stack. The deployment files can be found on the ``medco-deployment`` repository.

System Diagram
##############

.. figure:: medco_implementation_diagram.png
    :align: left

This image shows the system diagram of deployed MedCo node.


Services (Docker Containers)
############################

i2b2-server
-----------
WildFly v10.0.0 is used. It is configured to serve HTTP only.

**Files**

WildFly root directory is ``/opt/jboss/wildfly/`` and is self-contained: no file outside of this folder is used.

- ``standalone/``: files of the running instance (when running in standalone mode)
- ``standalone/configuration/``: configuration files of Tomcat and the running cells made available to the runtime
    - ``*app``: configuration folders of the i2b2 cells
    - ``logging.properties``: configuration of WildFly logging
    - ``standalone.xml``: configuration of WildFly
    - ``mgmt-users.properties``: WildFly admin users configuration
- ``standalone/log/``: Wildfly system and web applications logs (also printed to the docker console)
- ``standalone/deployments/``: web services deployed in the runtime
    - ``*-ds.xml`` files: JDBC data sources (connection information to database)
    - ``*jdbc*.jar`` files: JDBC drivers to connect to different databases
    - ``i2b2.war``: axis2 installation folder (renamed as ``i2b2.war`` to produce to get the ``i2b2`` path in the URL)

I2b2 deployment is in ``/opt/jboss/wildfly/standalone/deployments/i2b2.war/``

- ``WEB-INF/``: services and other files deployed in the runtime
    - ``WEB-INF/classes/``: some Axis2 system files (classes, log configuration, etc.)
    - ``WEB-INF/conf/``: Axis2 configuration
    - ``WEB-INF/lib/``: libraries available to the deployed services
    - ``WEB-INF/services/``: Deployed Axis2 services (``.aar`` Axis Archive files), all the i2b2 cells are there (service file is embedded in the archive)
- ``axis2-web/``: Axis2 web administration tool


**Web Administration Tools**

- ``http://<server>:9990/``: WildFly Web Administration
    - Default credentials: admin/prigen2017
- ``http://<server>:8080/i2b2/``: Axis2 Web Administration
    - Default credentials: admin/axis2

**Ports Exposed**

- 8080: WildFly HTTP port
- 9990: WildFly Web Admin


i2b2-web
--------
Lighttpd v.1.4.35 is used.
It is configured to serve HTTPS only with the provided certificate in the MedCo configuration folder.


**Files**

Web root server by lighttpd is ``/var/www/html/``. They are accessible (through HTTP or HTTPS standard ports) via the corresponding URL, example: ``https://<server>/i2b2-client``.

- ``i2b2-admin``: I2b2 administration tool (= the i2b2 webclient with an admin flag enabled)
    - Default credentials: i2b2/prigen2017
- ``i2b2-client``: Original i2b2 webclient (with the demo data)
    - Default credentials: demo/prigen2017
- ``phpmyadmin``: Management of the MySQL database (for the SHRINE database)
    - Default credentials: root/prigen2017
- ``phppgadmin``: Management of the PostgreSQL database (for the i2b2 database)
    - Default credentials: postgres/prigen2017
- ``shrine-client``: SHRINE-MedCo webclient (fork of the SHRINE webclient which itself if a fork of the i2b2 webclient)
    - Default credentials: medcoshrineuser/prigen2017
- ``index.html``: Index page with links to the different services.

Web server configuration is in ``/etc/lighttpd/``.

- ``lighttpd.conf``: general configuration of lighttpd (web root, logs location, modules enabled etc.)
- ``conf-enabled/10-fastcgi.conf``: configuration to enable CGI
- ``conf-enabled/15-fastcgi-php.conf``: configuration to enable PHP
- ``conf-enabled/10-ssl.conf``: SSL configuration

**Ports Exposed**

- 80: HTTP
- 443: HTTPS


shrine-server
-------------
Tomcat 8.0 is used.

**Files**

Tomcat root directory is ``/usr/local/tomcat/`` and is self-contained: no file outside of this folder is used.

- ``conf/``: Tomcat configuration files
    - ``server.xml``: Tomcat server configuration (listening ports, keystore for HTTPS certificates, etc.)
    - ``context.xml``: contains the JDBC data sources (connection information to database)
    - ``logging.properties``: configuration of Tomcat logging
    - ``tomcat-users.xml``: Tomcat admin users configuration
- ``log/``: Tomcat system and web applications logs (also printed to the docker console)
- ``webapps/``: web applications deployed in the runtime (each web application has the deployment descriptor in the ``WEB-INF/web.xml`` file)
    - ``shrine``: SHRINE core components
    - ``shrine-dashboard``: SHRINE dashboard
    - ``steward``: SHRINE data steward
    - ``shrine-meta``: SHRINE metadata
- ``lib/``: Files made available to the runtime of the web applications
    - ``AdapterMappings.xml``: SHRINE translation mapping
    - ``shrine.conf``: SHRINE configuration file

**Web Administration Tools**

- ``https://<server>:6443/``: Tomcat Web Administration
    - Default credentials: admin/prigen2017
- ``https://<server>:6443/shrine-dashboard``: SHRINE Dashboard
    - Default credentials: medcoadmin/prigen2017
- ``https://<server>:6443/steward``: SHRINE Data Steward
    - Default credentials: medcoadmin/prigen2017

**Ports Exposed**

- 6060: HTTP (redirected to HTTPS)
- 6443: HTTPS


unlynx
------
Golang 1.8 is used. At startup the Unlynx binary is exported to the MedCo configuration volume at ``/opt/medco-configuration/unlynxI2b2``
in order to be used by the MedCo cell from the i2b2-server service.

**Files**

The ``GOPATH`` is ``/go/`` and contains all the sources and executables.

- ``bin``: compiled binaries
- ``src``: go sources (contains all the installed dependencies)
    - ``github.com/lca1/unlynx/``: unlynx sources
    - ``gopkg.in/dedis/onet.v1/``: Onet library (cothority code)

**Ports Exposed**

- 2000: Cothority port (control)
- 2001: Cothority port (data)

i2b2-database
-------------
PostreSQL v9.6 is used.
This is a simple PostgreSQL server running, containing the i2b2 data. See phpPgAdmin for browsing the data.

**Port Exposed**

- 5432: PostgreSQL


shrine-database
---------------
MySQL v5.5 is used.
This is a simple MySQL server running, containing the SHRINE data. See phpMyAdmin for browsing the data.

**Port Exposed**

- 3306: MySQL


.. _lbl_config_folder:

MedCo Configuration Folder
##########################
In most of the deployed service there is a MedCo configuration folder at the path ``/opt/medco-configuration``.
It contains the configuration that depends on the nodes, such as some adresses, keys, etc.
It is mounted in the Docker container through a Docker volume.
Some example configurations are stored under ``configuration-profiles/`` on the ``medco-deployment`` repository.

Configuration Files specific to a node
--------------------------------------

- ``cacert.pem``: certificate of the MedCo certificate authority that establishes trust between SHRINE services and that signs HTTPS certificates
- ``group.toml``: public key of the collective authority (list of the public keys of all the unlynx nodes)
- ``srvX-public.toml``: public key of the unlynx node
- ``srvX-private.toml``: private key of the unlynx node
- ``srvX-ddtsecrets.toml``: secrets of the nodes for the deterministic tagging (generated at runtime)
- ``srvX.keystore``: Keystore of the node for Tomcat (contains the certificate of the CA, the private and public keys of the node, and the certificate of the node signed by the CA)
- ``srvX.pem``: certificate signed by the CA for the web server to serve HTTPS
- ``shrine_downstream_nodes.conf``: file included in the ``shrine.conf`` configuration file that lists the URLs of all the nodes part of the network


Configuration Generation Tool
-----------------------------
The generation script can be found at ``resources/config-generation-tool/generate-configuration-profile.sh`` on the ``medco-deployment`` repository.
It creates a new certificate authority, and for each node:

- generate a pair of SSL keys
- generate a certificate signature request and sign it with the CA
- import in the keystore the certificates and keys
- generate lighttpd certificate
- add the URL of the node in the ``shrine_downstream_nodes.conf``
- generate the unlynx pair of keys and assemble the public keys in the ``group.toml``
- generate the docker-compose file to build and run MedCo
