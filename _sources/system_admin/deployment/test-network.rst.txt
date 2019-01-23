.. _lbl_deployment_test-network:

Network Test Deployment
-----------------------

Profile *test-network*

This test profile deploys a MedCo node part of a MedCo network on a machine for test purposes.
It can be deployed on a machine reachable by the other nodes of the network.
The version of the docker images used are the latest released versions.


Preliminaries
'''''''''''''

First step is to get the MedCo Deployment latest release, and separately the IRCT repository.

.. code-block:: bash

    $ cd ~
    $ wget https://github.com/lca1/medco-deployment/archive/v0.1.1.tar.gz
    $ tar xvzf v0.1.1.tar.gz
    $ mv medco-deployment-0.1.1 medco-deployment
    $ git clone -b MedCo-v0.1.1 https://github.com/lca1/IRCT.git


Generation of the Deployment Profile
''''''''''''''''''''''''''''''''''''
Next the *compose and configuration profiles* must be generated using a script.
This script is executed in two steps, and individually by each node of the network.
- **Step 1**: each node generates its keys and certificates, and shares its public ones with the other nodes
- **Step 2**: each node gathers the public keys and certificates of the others

For step 1, the network name should be common to all the nodes.
Beforehand the different parties should have agreed on the nodes members of the network, and assigned to each a
node index (starting from 0, to n-1, n being the total number of nodes).
The node domain name should be accessible by the other nodes.

.. code-block:: bash

    $ cd ~/medco-deployment/resources/profile-generation-scripts/test-network
    $ bash step1.sh <network name> <node index> <node domain name>

This script will generate part of the *configuration profile*, including a file ``srv<node index>-public.tar.gz``.
This file should be shared with the other nodes, and all of them need to place it in the *configuration profile* folder,
such that all the ``srv<node index>-public.tar.gz`` files are present at the same place.

Once this is done, the step 2 can be executed:

.. code-block:: bash

    $ bash step2.sh <network name> <node index>

The deployment profile is now ready to be used.


MedCo Node Deployment (except IRCT)
'''''''''''''''''''''''''''''''''''

Next step is to download or build the docker images, and run the node:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-network-<network name>
    $ docker-compose pull
    $ docker-compose build
    $ docker-compose up

Wait some time for the initialization of the containers to be done (until the logging stops), this can take up to 10 minutes.
For the subsequent runs, the startup will be faster.


IRCT Configuration and Deployment
'''''''''''''''''''''''''''''''''

Currently IRCT must be configured manually and deployed separately, this will change in the future.

Edit the file ``~/IRCT/deployments/.env`` and adjust to your case:

.. code-block:: bash

    MEDCO_NODE_URL=https://<node domain name>
    MEDCO_NODE_IDX=<node index>
    MEDCO_PROFILE_NAME=test-network-<network name>

Copy all the certificates obtained from the previous step to the folder ``~/IRCT/deployments/irct/volumes/certificates/``:

.. code-block:: bash

    $ cp ~/medco-deployment/configuration-profiles/test-network-<network name>/*.crt ~/IRCT/deployments/irct/volumes/certificates/

Then, build and run the IRCT container:

.. code-block:: bash

    $ cd ~/IRCT/deployments
    $ docker-compose -f docker-compose.medco.test-network.yml build
    $ chmod -R a+rw ../
    $ docker-compose -f docker-compose.medco.test-network.yml up

Use the pgAdmin tool to add the IRCT configuration (see :ref:`lbl_configuration_postgresql`).
With the query tool, execute the following SQL in the database ``irct`` by adapting to your case:

.. code-block:: sql

    select add_i2b2_medco_resource(
        'i2b2-medco-test-network',
        'https://<node 0 domain name>/i2b2/services/,https://<node 1 domain name>/i2b2/services/,...',
        'i2b2medco,i2b2medco,i2b2medco',
        'medcouser',
        'demouser',
        'true',
        'false',
        'edu.harvard.hms.dbmi.bd2k.irct.ri.medco.I2B2MedCoResourceImplementation',
        'TREE'
    );

Finally, restart IRCT to account for the new configuration by hitting ``Ctrl+C`` in IRCT terminal, and starting it again:

.. code-block:: bash

    $ docker-compose -f docker-compose.medco.test-network.yml up


In order to stop the containers, simply hit ``Ctrl+C`` in all the active windows.
Follow the instructions from :ref:`lbl_configuration_keycloak` to be able to test the deployment.


Test the deployment
'''''''''''''''''''

In order to test that the development deployment of MedCo is working, access Glowing Bear in your web browser at ``http://<domain name>``
and use the credentials previously configured.

The default test data will not be working (the queries made will fail), as the data is not encrypted with the keys that were generated.
Use first the MedCo loader (see :ref:`lbl_loading_data`) to be able to test the deployment.
The database address to use is ``<domain name>:5432`` with the database ``i2b2medco``.

Note that by default the certificate generated by the script are self-signed, and when using Glowing Bear, the browser will issue a security warning.
To use your own valid certificates, see :ref:`lbl_configuration_https`.
