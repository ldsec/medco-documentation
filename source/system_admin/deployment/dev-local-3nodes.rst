.. _lbl_deployment_dev-local-3nodes:

Local Development Deployment
----------------------------

Profile *dev-local-3nodes*

This deployment profile deploys 3 MedCo nodes on a single machine for development purposes.
It is meant to be used only on your local machine, i.e. ``localhost``.
The version of the docker images used are all *dev*, i.e. the ones built from the development version of the different source codes.
They are available either through Docker Hub, or built locally.

MedCo Node Deployment (except IRCT)
'''''''''''''''''''''''''''''''''''

First step is to clone the ``medco-deployment`` repository with the correct branch.
This example gets the data in the home directory of the current user, but that can be changed.

.. code-block:: bash

    $ cd ~
    $ git clone -b dev https://github.com/lca1/medco-deployment.git

Next step is to download or build the docker images:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/dev-local-3nodes
    $ docker-compose pull
    $ docker-compose build

Next step is to run the nodes. They will run simultaneously, and the logs of the running containers will maintain the console captive.
No configuration changes are needed in this scenario before running the nodes.
To run them:

.. code-block:: bash

    $ docker-compose up

Wait some time for the initialization of the containers to be done (up to the message: *"i2b2-medco-srv... - Started x of y services (z services are lazy, passive or on-demand)"*), this can take up to 10 minutes.
For the subsequent runs, the startup will be faster.

IRCT Deployment and Configuration
'''''''''''''''''''''''''''''''''

First step is to clone the ``IRCT`` repository with the correct branch.

.. code-block:: bash

    $ cd ~
    $ git clone -b fork/thehyve https://github.com/lca1/IRCT.git

Currently IRCT must be deployed separately, this will change in the future:

.. code-block:: bash

    $ cd ~/IRCT/deployments
    $ docker-compose -f docker-compose.medco.dev-local-3nodes.yml build

In a separate terminal run the IRCT container:

.. code-block:: bash

    $ chmod -R a+rw ../
    $ docker-compose -f docker-compose.medco.dev-local-3nodes.yml up

Again, the initial startup takes up a few minutes as IRCT is compiled at that point (up to the message: *"irct_1... - Started x of y services (z services are lazy, passive or on-demand)"*).

Glowing Bear Deployment and Configuration
'''''''''''''''''''''''''''''''''''''''''

First step is to clone the ``glowing-bear`` repository with the correct branch.

.. code-block:: bash

    $ cd ~
    $ git clone -b picsure https://github.com/lca1/glowing-bear-medco.git

Glowing Bear is deployed separately for development, as we use its very practical development server:

.. code-block:: bash

    $ cd ~/glowing-bear-medco/deployment
    $ docker-compose build dev-server


In another separate terminal run the glowing bear development server:

.. code-block:: bash

    $ docker-compose up dev-server

In order to stop the containers, simply hit ``Ctrl+C`` in all the active windows.

Keycloak Configuration
''''''''''''''''''''''

Follow the instructions from :ref:`lbl_configuration_keycloak` and then you should be able to login in Glowing Bear.

Test the deployment
'''''''''''''''''''

In order to test that the development deployment of MedCo is working, access Glowing Bear in your web browser at ``http://localhost:4200``
and use the credentials previously configured during the :ref:`lbl_configuration_keycloak`. If you are new to Glowing Bear you can watch the `Glowing Bear user interface walkthrough <https://glowingbear.app>`_ video.

By default MedCo loads a specific test data, refer to :ref:`lbl_test_data_description` for expected results to queries.
To load a dataset, follow the guide :ref:`lbl_loading_data`.
For reference, the database address (host) to use during loading is ``localhost:5432`` and the databases ``i2b2medcosrv0``, ``i2b2medcosrv1`` and ``i2b2medcosrv2``.
