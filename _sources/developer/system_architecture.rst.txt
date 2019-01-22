System Architecture
===================

.. figure:: system_architecture.png
    :align: center

Containers
++++++++++

medco-unlynx
------------
The software executing the distributed cryptographic protocols, based on Unlynx.

i2b2-medco
----------
The i2b2 stack (all the cells), with the addition of the MedCo i2b2 cell to process the queries.
This cell communicates with *medco-unlynx* to execute the distributed cryptographic protools.

irct
----
The query translation and broadcasting layer.


glowing-bear
------------
Nginx web server serving Glowing Bear and the crypto module.


keycloak
--------
OpenID Connect identity provider.

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
