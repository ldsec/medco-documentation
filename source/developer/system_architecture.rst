System Architecture
===================

.. figure:: system_architecture_v0.2.png
    :align: center

Containers
++++++++++

medco-connector
---------------
Component orchestrating the MedCo query at the clinical site. Implements the resource-side of the PIC-SURE API. It
communicates with *medco-unlynx* to execute the distributed cryptographic protocols.


medco-unlynx
------------
The software executing the distributed cryptographic protocols, based on Unlynx.


i2b2
----------
The i2b2 stack (all the cells).


picsure
-------
The query translation and broadcasting layer.


glowing-bear-medco
------------------
Nginx web server serving Glowing Bear and the javascript crypto module.


medco-loader
------------
ETL tool to encrypt and load data into MedCo.


keycloak
--------
OpenID Connect identity provider, providing user management and their authentication to MedCo.


postgresql
----------
The SQL database used by all other services, contains all the data.


pg-admin
--------
A web-based administration tool for the PostgreSQL database.


nginx
-----
Web server and (HTTPS-enabled) reverse proxy.


php-fpm
-------
PHP processor running with FPM (FastCGI Process Manager), used by Nginx.
Executes the PHP code needed to serve the genomic annotations.
