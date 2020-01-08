.. _lbl_deployment_test-network:

Network Test Deployment
-----------------------

Profile *test-network*

This test profile deploys an arbitrary set of MedCo nodes independently in different machines that together form a MedCo
network. This deployment assumes each node is deployed in a single dedicated machine. All the machines have to be
reachable between each other. Nodes should agree on a network name and individual indexes beforehand (to be assigned a
unique ID). The node with index 0 is the central node, which is the only one running Glowing Bear, PICSURE and Keycloak.

The next set of steps must be **executed individually by each node of the network**.


Preliminaries
'''''''''''''

First step is to get the MedCo Deployment latest release at each node.

.. code-block:: bash

    $ cd ~
    $ wget https://github.com/ldsec/medco-deployment/archive/v0.2.1-1.tar.gz
    $ tar xvzf v0.2.1-1.tar.gz
    $ mv medco-deployment-0.2.1-1 medco-deployment


Generation of the Deployment Profile
''''''''''''''''''''''''''''''''''''

Next the *compose and configuration profiles* must be generated using a script, executed in two steps.

- **Step 1**: each node generates its keys and certificates, and shares its public information with the other nodes

- **Step 2**: each node collects the public keys and certificates of the all the other nodes

For step 1, the network name should be common to all the nodes. <node DNS name> corresponds to the machine domain name
where the node is being deployed. As mentioned before the different parties should have agreed beforehand on the members
of the network, and assigned an index to each different node to construct its UID (starting from 0, to n-1, n being the
total number of nodes). Remember that node 0 is the central node.

.. code-block:: bash

    $ cd ~/medco-deployment/resources/profile-generation-scripts/test-network
    $ bash step1.sh <network name> <node index> <node DNS name>

This script will generate the *compose profile* and part of the *configuration profile*, including a file
``srv<node index>-public.tar.gz``. This file should be shared with the other nodes, and all of them need to place it in
their *configuration profile* folder (``~/medco-deployment/configuration-profiles/test-network-<network name>-node<node index>``).

Once all nodes have shared their ``srv<node index>-public.tar.gz`` file with all other nodes, step 2 can be executed:

.. code-block:: bash

    $ bash step2.sh <network name> <node index>

At this point, it is possible to edit the default configuration generated in
``~/medco-deployment/configuration-profiles/test-network-<network name>-node<node index>/.env``. This is needed if you
want to modify the default passwords. When editing this file, be careful to change only the passwords and not the other
values. Note that setting the passwords that way works only on the first deployment. If the passwords need to be updated
later, you should use the specific component way of modifying password.

The deployment profile is now ready to be used.


MedCo Stack Deployment
''''''''''''''''''''''

Next step is to download the docker images and run the node. The process is different for the central node and for the
other nodes. If you manage the central node run the following:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-network-<network name>-node0
    $ docker-compose -f docker-compose.common.yml -f docker-compose.node.yml -f docker-compose.central.yml pull
    $ docker-compose -f docker-compose.common.yml -f docker-compose.node.yml -f docker-compose.central.yml up -d

If you manage a node other than the central one (index > 0), run the following:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-network-<network name>-node<node index>
    $ docker-compose -f docker-compose.common.yml -f docker-compose.node.yml pull
    $ docker-compose -f docker-compose.common.yml -f docker-compose.node.yml up -d

Wait some time for the initialization of the containers to be done, this can take up to 10 minutes. For the subsequent
runs, the startup will be faster. You can use ``docker-compose -f docker-compose... stop`` to stop the containers.


Keycloak Configuration
''''''''''''''''''''''

Follow the instructions from :ref:`lbl_configuration_keycloak` and then you should be able to login in Glowing Bear.


Data Loading
''''''''''''

Contrary to the other deployment profiles **the default test data will not be working (the queries made will fail)**
since the data is not encrypted with the collective key that was generated (encryption key derived from all the nodes'
public keys). Run the MedCo loader (see :ref:`lbl_loading_data`) to be able to test this deployment. For reference, the
database address (host) to use during loading is ``<domain name>:5432`` and the database ``i2b2medco``.


Test the deployment
'''''''''''''''''''

In order to test that the network deployment of MedCo is working, access Glowing Bear in your web browser at
``http://<node domain name>`` and use the credentials previously configured during the :ref:`lbl_configuration_keycloak`.
If you are new to Glowing Bear you can watch the `Glowing Bear user interface walkthrough <https://glowingbear.app>`_ video.

Note that by default the certificates generated by the script are self-signed and thus, when using Glowing Bear, the
browser will issue a security warning. To use your own valid certificates, see :ref:`lbl_configuration_https`.
