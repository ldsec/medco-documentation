.. _lbl_deployment_dev-local-3nodes:

Local Development Deployment
----------------------------

Profile *dev-local-3nodes*

This deployment profile deploys 3 MedCo nodes on a single machine for development purposes. It is meant to be used only
on your local machine, i.e. ``localhost``. The tags of the docker images used are all *dev*, i.e. the ones built from
the development version of the different source codes. They are available either through Docker Hub, or built locally.


MedCo Stack Deployment (except Glowing Bear)
''''''''''''''''''''''''''''''''''''''''''''

First step is to clone the ``medco-deployment`` repository with the correct branch.
This example gets the data in the home directory of the current user, but that can be changed.

.. code-block:: bash

    $ cd ~
    $ git clone -b dev https://github.com/ldsec/medco-deployment.git

Next step is to build the docker images:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/dev-local-3nodes
    $ docker-compose build

Note that instead of building the *dev* docker images locally, it is possible to download them from Docker Hub by
using ``docker-compose pull``, but there is no guarantee on the current status of those images are they are automatically built.

Next step is to run the nodes. They will run simultaneously, and the logs of the running containers will maintain the console captive.
No configuration changes are needed in this scenario before running the nodes.
To run them:

.. code-block:: bash

    $ docker-compose up

Wait some time for the initialization of the containers to be done (up to the message: *"i2b2-medco-srv... - Started x of y services (z services are lazy, passive or on-demand)"*), this can take up to 10 minutes.
For the subsequent runs, the startup will be faster.


Glowing Bear Deployment
'''''''''''''''''''''''

First step is to clone the ``glowing-bear`` repository with the correct branch.

.. code-block:: bash

    $ cd ~
    $ git clone -b dev https://github.com/ldsec/glowing-bear-medco.git

Glowing Bear is deployed separately for development, as we use its convenient live development server:

.. code-block:: bash

    $ cd ~/glowing-bear-medco/deployment
    $ docker-compose up dev-server

Note that the first run will take a significant time in order to build everything.

In order to stop the containers, simply hit ``Ctrl+C`` in all the active windows.


Keycloak Configuration
''''''''''''''''''''''

Follow the instructions from :ref:`lbl_configuration_keycloak` to be able to use Glowing Bear.


Test the deployment
'''''''''''''''''''

In order to test that the development deployment of MedCo is working, access Glowing Bear in your web browser at
``http://localhost:4200`` and use the credentials previously configured during the :ref:`lbl_configuration_keycloak`.
If you are new to Glowing Bear you can watch the `Glowing Bear user interface walkthrough <https://glowingbear.app>`_ video.

By default MedCo loads a specific test data, refer to :ref:`lbl_test_data_description` for expected results to queries.
To load a dataset, follow the guide :ref:`lbl_loading_data`. For reference, the database address (host) to use during
loading is ``localhost:5432`` and the databases ``i2b2medcosrv0``, ``i2b2medcosrv1`` and ``i2b2medcosrv2``.
