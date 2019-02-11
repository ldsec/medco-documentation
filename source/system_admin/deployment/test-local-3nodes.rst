.. _lbl_deployment_test-local-3nodes:

Local Test Deployment
---------------------

Profile *test-local-3nodes*

This test profile deploys 3 MedCo nodes on a single machine for test purposes.
It can be used either on your local machine, or any other machine to which you have access.
The version of the docker images used are the latest released versions.
This profile is for example used for the `MedCo public demo <https://medco-demo.epfl.ch>`_.

First step is to get the MedCo Deployment latest release, and separately the IRCT repository.

.. code-block:: bash

    $ cd ~
    $ wget https://github.com/lca1/medco-deployment/archive/v0.1.1b.tar.gz
    $ tar xvzf v0.1.1b.tar.gz
    $ mv medco-deployment-0.1.1b medco-deployment
    $ git clone -b MedCo-v0.1.1 https://github.com/lca1/IRCT.git

Next step is to download or build the docker images:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-local-3nodes
    $ docker-compose pull
    $ docker-compose build

Currently IRCT must be deployed separately, this will change in the future:

.. code-block:: bash

    $ cd ~/IRCT/deployments
    $ docker-compose -f docker-compose.medco.test-local-3nodes.yml build

Next, if running on another machine than the local host, a configuration file must be changed.
If running on the local host, the default settings can be left in place.
Edit the file ``~/medco-deployment/compose-profiles/test-local-3nodes/.env`` to reflect your configuration.
For example:

.. code-block:: bash

    MEDCO_NODE_URL=https://medco-demo.epfl.ch
    HTTP_SCHEME=https

``MEDCO_NODE_URL`` should include the protocol and the fully qualified domain name of the host,
``HTTP_SCHEME`` should be ``http`` or ``https``.

Follow :ref:`lbl_configuration_https` to set up the certificates needed for HTTPS. 
If you are deploying on another host than the local host without HTTPS, take note of the following: :ref:`lbl_configuration_keycloak_no_https`.

Next step is to run the nodes. They will run simultaneously, and the logs of the running containers will maintain the console captive.
No configuration changes are needed in this scenario before running the nodes.
To run them:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-local-3nodes
    $ docker-compose up

Wait some time for the initialization of the containers to be done (up to the message: *"i2b2-medco-srv... - Started x of y services (z services are lazy, passive or on-demand)"*), this can take up to 10 minutes.
For the subsequent runs, the startup will be faster.

Then, in a separate terminal run the IRCT container:

.. code-block:: bash

    $ cd ~/IRCT/deployments
    $ chmod -R a+rw ../
    $ docker-compose -f docker-compose.medco.test-local-3nodes.yml up

Again, the initial startup takes up a few minutes as IRCT is compiled at that point (up to the message: *"irct_1... - Started x of y services (z services are lazy, passive or on-demand)"*).

In order to stop the containers, simply hit ``Ctrl+C`` in all the active windows.

Keycloak Configuration
''''''''''''''''''''''

Follow the instructions from :ref:`lbl_configuration_keycloak` and then you should be able to login in Glowing Bear.

Test the deployment
'''''''''''''''''''

In order to test that the development deployment of MedCo is working, access Glowing Bear in your web browser at ``http://<domain name>`` and use the credentials previously configured during the :ref:`lbl_configuration_keycloak`. If you are new to Glowing Bear you can watch the `Glowing Bear user interface walkthrough <https://glowingbear.app>`_ video.

By default MedCo loads a specific test data, refer to :ref:`lbl_test_data_description` for expected results to queries.
To load a dataset, follow the guide :ref:`lbl_loading_data`.
For reference, the database address to use during loading is ``<domain name>:5432`` and the databases ``i2b2medcosrv0``, ``i2b2medcosrv1`` and ``i2b2medcosrv2``.
