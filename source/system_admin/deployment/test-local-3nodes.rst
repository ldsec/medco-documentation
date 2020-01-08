.. _lbl_deployment_test-local-3nodes:

Local Test Deployment
---------------------

Profile *test-local-3nodes*

This test profile deploys 3 MedCo nodes on a single machine for test purposes. It can be used either on your local
machine, or any other machine to which you have access. The version of the docker images used are the latest released
versions. This profile is for example used for the `MedCo public demo <https://medco-demo.epfl.ch>`_.


MedCo Stack Deployment
''''''''''''''''''''''

First step is to get the MedCo Deployment latest release.

.. code-block:: bash

    $ cd ~
    $ wget https://github.com/ldsec/medco-deployment/archive/v0.2.1-1.tar.gz
    $ tar xvzf v0.2.1-1.tar.gz
    $ mv medco-deployment-0.2.1-1 medco-deployment

Next step is to download the docker images:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-local-3nodes
    $ docker-compose pull

The default configuration of the deployment is suitable if the stack is deployed on your local host, and if you do not
need to modify the default passwords. If so, edit the file ``~/medco-deployment/compose-profiles/test-local-3nodes/.env``
to reflect your configuration. For example:

.. code-block:: bash

    MEDCO_NODE_HOST=medco-demo.epfl.ch
    HTTP_SCHEME=https
    POSTGRES_PASSWORD=postgres1
    PGADMIN_PASSWORD=admin
    KEYCLOAK_PASSWORD=keycloak
    I2B2_WILDFLY_PASSWORD=admin
    I2B2_SERVICE_PASSWORD=pFjy3EjDVwLfT2rB9xkK
    I2B2_USER_PASSWORD=demouser

``MEDCO_NODE_URL`` should be the fully qualified domain name of the host, ``HTTP_SCHEME`` should be ``http`` or
``https``. The other fields control the default passwords for the various services running. Note that setting the
passwords that way works only on the first deployment. If the passwords need to be updated later, you should use the
specific component way of modifying password.

Follow :ref:`lbl_configuration_https` to set up the certificates needed for HTTPS.
If you are deploying on another host than the local host without HTTPS take note of the following:
:ref:`lbl_configuration_keycloak_no_https`.

Final step is to run the nodes, all three will run simultaneously:

.. code-block:: bash

    $ docker-compose up

Wait some time for the initialization of the containers to be done (up to the message: *"i2b2-medco-srv... - Started x
of y services (z services are lazy, passive or on-demand)"*), this can take up to 10 minutes. For the subsequent runs,
the startup will be faster. In order to stop the containers, hit ``Ctrl+C`` in the active window.

You can use the command ``docker-compose up -d`` instead to run MedCo in the background and thus not keeping the console
captive. In that case use ``docker-compose stop`` to stop the containers.


Keycloak Configuration
''''''''''''''''''''''

Follow the instructions from :ref:`lbl_configuration_keycloak` to be able to use Glowing Bear.


Test the deployment
'''''''''''''''''''

In order to test that the local test deployment of MedCo is working, access Glowing Bear in your web browser at
``http(s)://<domain name>`` and use the credentials previously configured during the :ref:`lbl_configuration_keycloak`.
If you are new to Glowing Bear you can watch the `Glowing Bear user interface walkthrough <https://glowingbear.app>`_ video.

By default MedCo loads a specific test data, refer to :ref:`lbl_test_data_description` for expected results to queries.
To load a dataset, follow the guide :ref:`lbl_loading_data`. For reference, the database address (host) to use during
loading is ``<domain name>:5432`` and the databases ``i2b2medcosrv0``, ``i2b2medcosrv1`` and ``i2b2medcosrv2``.
