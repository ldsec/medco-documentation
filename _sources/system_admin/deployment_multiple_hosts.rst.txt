.. _lbl_deploy_multiple_servers:

Deploying MedCo on Multiple Servers 
------------------------------------
This short guide will show you how to generate a working configuration in order to deploy 3 nodes of the full MedCo stack
on separate machines with the help of Docker, Docker-Compose and a configuration script.

Use the previous guide :ref:`lbl_deploy_single_server` to clone the ``medco-deployment`` and install the required dependencies on your system.
Before building the Docker images it is needed to generate the configuration profile, this can be done on your machine or on one of the servers that will serve a MedCo node.

**Generating the configuration profile**

Execute the tool with the properly constructed arguments:

.. code-block:: bash

    $ cd ~/medco-deployment/resources/config-generation-tool
    $ bash generate-dev-configuration-profile.sh test-3nodes 1.1.1.1 2.2.2.2 3.3.3.3

Explanation of the arguments:

- ``test-3nodes``: name of the configuration profile, the folders ``compose-profiles/test-3nodes`` and ``configuration-profiles/test-3nodes`` will be created
- ``A.B.C.D``: the IP address of the server number X

**Deploying the nodes**

Now that the configuration profile ``test-3nodes`` is generated, repeat the operation of cloning the ``medco-deployment``, ``IRCT`` and ``glowing-bear`` repositories
and installing the dependencies on all the servers that will be MedCo nodes.
Next copy on those servers the configuration profile, that is the 2 folders ``compose-profiles/test-3nodes`` and ``configuration-profiles/test-3nodes``.

From there the  next steps are very similar to the single server scenario, build and run the nodes on all the servers.
On server number 0:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-3nodes
    $ docker-compose -f docker-compose-srv0.yml build
    $ docker-compose -f docker-compose-srv0.yml up

.. code-block:: bash

    $ cd ~/IRCT/deployments
    $ docker-compose -f xxx build
    $ docker-compose -f xxx up

.. code-block:: bash

    $ cd ~/glowing-bear/
    $ docker-compose -f xxx build
    $ docker-compose -f xxx up

On server number 1:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-3nodes
    $ docker-compose -f docker-compose-srv1.yml build
    $ docker-compose -f docker-compose-srv1.yml up

.. code-block:: bash

    $ cd ~/IRCT/deployments
    $ docker-compose -f xxx build
    $ docker-compose -f xxx up

.. code-block:: bash

    $ cd ~/glowing-bear/
    $ docker-compose -f xxx build
    $ docker-compose -f xxx up

On server number 2:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-3nodes
    $ docker-compose -f docker-compose-srv2.yml build
    $ docker-compose -f docker-compose-srv2.yml up

.. code-block:: bash

    $ cd ~/IRCT/deployments
    $ docker-compose -f xxx build
    $ docker-compose -f xxx up

.. code-block:: bash

    $ cd ~/glowing-bear/
    $ docker-compose -f xxx build
    $ docker-compose -f xxx up