.. _lbl_deployment_test-network:

Network Test Deployment
-----------------------

Profile *test-network*

This test profile deploys an arbitrary set of MedCo nodes independently in different machines that together form a MedCo network. This deployment assumes each node is deployed in a single dedicated machine. All the machines have to be reachable between each other. Nodes should agree on a network name and individual indexes beforehand (to be assigned an UID). The next set of steps must be **executed individually by each node of the network**.

This guide is for the latest released version of the docker images.

Preliminaries
'''''''''''''

First step is to get the MedCo Deployment latest release at each node.

.. code-block:: bash

    $ cd ~
    $ wget https://github.com/lca1/medco-deployment/archive/v0.1.1b.tar.gz
    $ tar xvzf v0.1.1b.tar.gz
    $ mv medco-deployment-0.1.1b medco-deployment


Generation of the Deployment Profile
''''''''''''''''''''''''''''''''''''

Next the *compose and configuration profiles* must be generated using a script.
This script is executed in two steps.

- **Step 1**: each node generates its keys and certificates, and shares its public information with the other nodes

- **Step 2**: each node collects the public keys and certificates of the all the other nodes

For step 1, the network name should be common to all the nodes. A <node domain name> corresponds to the machine domain name where the node is being deployed.
As mentioned before the different parties should have agreed beforehand on the members of the network, and assigned an index to each different node to construct its UID (starting from 0, to n-1, n being the total number of nodes).

.. code-block:: bash

    $ cd ~/medco-deployment/resources/profile-generation-scripts/test-network
    $ bash step1.sh <network name> <node index> <node domain name>

This script will generate part of the *configuration profile*, including a file ``srv<node index>-public.tar.gz``.
This file should be shared with the other nodes, and all of them need to place it in the *configuration profile* folder, ``~/medco-deployment/configuration-profiles/test-network-<network name>-node<node index>``, such that all the files inside ``srv<node index>-public.tar.gz`` are in the same location in each node.

Once this is done, step 2 can be executed:

.. code-block:: bash

    $ bash step2.sh <network name> <node index>

The deployment profile is now ready to be used.


MedCo Node Deployment (except IRCT)
'''''''''''''''''''''''''''''''''''

Next step is to download and build the docker images, and run a node.

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-network-<network name>-node<node index>
    $ docker-compose pull
    $ docker-compose build
    $ docker-compose up

Wait some time for the initialization of the containers to be done (up to the message: *"- Started x of y services (z services are lazy, passive or on-demand)"*), this can take up to 10 minutes.
For the subsequent runs, the startup will be faster.


IRCT Deployment and Configuration
'''''''''''''''''''''''''''''''''

Currently IRCT must be configured manually and deployed separately in each of the nodes.  This will change in the future. 

.. code-block:: bash

    $ cd ~
    $ git clone -b MedCo-v0.1.1 https://github.com/lca1/IRCT.git

Edit the file ``~/IRCT/deployments/.env`` and adjust for each node:

.. code-block:: bash

    MEDCO_NODE_URL=https://<node domain name>
    MEDCO_NODE_IDX=<node index>
    MEDCO_PROFILE_NAME=test-network-<network name>-node<node index>

Copy all the certificates obtained from the previous step to the folder ``~/IRCT/deployments/irct/volumes/certificates/``:

.. code-block:: bash

    $ cp ~/medco-deployment/configuration-profiles/test-network-<network name>-node<node index>/*.crt ~/IRCT/deployments/irct/volumes/certificates/

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

Keycloak Configuration
''''''''''''''''''''''

Follow the instructions from :ref:`lbl_configuration_keycloak` and then you should be able to login in Glowing Bear.

Data Loading
''''''''''''

Contrary to the other deployment profiles **the default test data will not be working (the queries made will fail)** since the data is not encrypted with the collective key that was generated (encryption key derived from all the nodes' public keys).
Run the MedCo loader (see :ref:`lbl_loading_data`) to be able to test this deployment.
For reference, the database address (host) to use during loading is ``<domain name>:5432`` and the database ``i2b2medco``.

Test the deployment
'''''''''''''''''''

In order to test that the network deployment of MedCo is working, access Glowing Bear in your web browser at ``http://<node domain name>`` and use the credentials previously configured during the :ref:`lbl_configuration_keycloak`. If you are new to Glowing Bear you can watch the `Glowing Bear user interface walkthrough <https://glowingbear.app>`_ video.

Note that by default the certificates generated by the script are self-signed and thus, when using Glowing Bear, the browser will issue a security warning.
To use your own valid certificates, see :ref:`lbl_configuration_https`.
