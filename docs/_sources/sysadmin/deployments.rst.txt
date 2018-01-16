Description of Deployments
==========================

i2b2-server
-----------

Files
.....
WildFly root directory is ``/opt/jboss/wildfly/`` and is self-contained: no file outside of this folder is used.

- ``standalone/``: files of the running instance (when running in standalone mode)
- ``standalone/configuration/``: configuration files of the running cells made available to the runtime (see details in documentation)
- ``standalone/log/``: wildfly logs (also  printed to the docker console)
- ``standalone/deployments/``: web services deployed in the runtime
    - ``*-ds.xml`` files: data sources (connection information to database)
    - ``*jdbc*.jar`` files: JDBC drivers to connect to different databases
    - ``i2b2.war``: axis2 installation folder (renamed as ``i2b2.war`` to produce to get the ``i2b2`` path in the URL)

I2b2 deployment is in ``/opt/jboss/wildfly/standalone/deployments/i2b2.war/``
- ``WEB-INF/``: services and other files deployed in the runtime
    - ``WEB-INF/classes/``: some Axis2 system files (classes, log configuration, etc.)
    - ``WEB-INF/lib/``: libraries available to the deployed services
    - ``WEB-INF/services/``: Deployed Axis2 services (``.aar`` Axis Archive files), all the i2b2 cells are there
- ``axis2-web/``: Axis2 web administration tool


Web Administration Tools
........................
TODO: URL
TODO: full list & description of the paths to put  in the documentation as ref(show only the most relevant here)
TODO: configuration / database connection / logs

Open Ports
..........
aaa
