Deployment Documentation
========================

..  toctree::

    deployment/deployed_description

This page explains how to deploy and configure MedCo.

**Deployment profiles**

When building and running MedCo, a *compose-profile* and a *configuration-profile* must be created and used.
A *compose-profile* contains the Docker Compose file that starts a MedCo node. Configurations like ports to expose, log levels, etc. can be set up there.
A *configuration-profile* is a configuration folder shared by the containers and contains things such as keys and certificates, see :ref:`lbl_config_folder`.

Deploying MedCo on a Single Server
----------------------------------
This short guide will show you how to deploy 3 nodes of the full MedCo stack on a single machine with the help of Docker and Docker-Compose.
Any kind of not too old Linux flavor should work, but it has only be tested on the following configuration:

- Operating System: Ubuntu 14.04.5 LTS, assumed to be freshly installed and up to date.
- Pre-requisite software: *git* (the rest of the dependencies will be automatically installed with a script).

First step is to clone the ``medco-deployment`` repository and to execute the script that will install the dependencies on your machine.
Among others, it will install Docker 17.12.0-ce and Docker-Compose 1.14.0.

.. code-block:: bash

    $ git clone https://c4science.ch/source/medco-deployment.git
    $ bash medco-deployment/resources/utility-scripts/ubuntu_prereqs_setup.sh

Next step is to build the docker images. They will be built from source, for this reason the very first build might
take a lot of time depending on the perfomance of your machine (up to 2 hours on a standard laptop, around 20 minutes on a powerful server).
In this specific case (i.e. 3 nodes running on a single machine) you can use the provided compose and configuration profiles, called ``dev-3nodes-samehost``.
As it name indicates, it is for development purposes, runs 3 nodes on a single server.

This command will build the first node from scratch:

.. code-block:: bash

    $ cd medco-deployment/compose-profiles/dev-3nodes-samehost
    $ docker-compose -f docker-compose-srv0.yml build

Because Docker will cache the images built at the previous step, building the 2 other nodes will be much faster:

.. code-block:: bash

    $ docker-compose -f docker-compose-srv1.yml build
    $ docker-compose -f docker-compose-srv2.yml build

Next step is to run the nodes. They need to be running in parallel, and the logs of the running containers will maintain the console captive.
For this reason it is recommended to use *screen* to run them. Use ``screen -dRR`` to start a new screen session.
``Ctrl+A-C`` will create a new window: create at least 3 of them. ``Ctrl+A-P`` and ``Ctrl+A-N`` allow to navigate between the windows.
Hit simply ``Ctrl+D`` to close the current window. Use ``Ctrl+A-D`` to detach from the screen instance. Once detached you are back in the normal console
and can simply run again ``screen -dRR`` to attach to the running screen session.

Run the first node:

.. code-block:: bash

    $ docker-compose -f docker-compose-srv0.yml up

In a separate *screen* window the second:

.. code-block:: bash

    $ docker-compose -f docker-compose-srv1.yml up

And in another separate window the last one:

.. code-block:: bash

    $ docker-compose -f docker-compose-srv2.yml up

The first time each of the node runs, the database will be initialized with the structure and the i2b2 demo data,
it will take a few minutes so do not interrupt this loading!
The next times the nodes are ran, they take 1-2 minutes to be up and running. In order to stop a node,
simply hit ``Ctrl+C`` in window where the node is active.

**Important note about the ports used when running several nodes a single host**

Since they are running on the same host, the ports used for the different services had to be adapted.
The modification follow the following logic: if the port is specified as being ``80`` on the documentation,
the port exposed on the host for the first node will be ``82``, for the second node ``84``, and for the third ``86``.
That is, they are incremented by 2 for every node.

**Testing that the nodes are working**

In order to test that a *single node* is working, you can access the index page at ``<your_server_address>:82`` and
click on the ``I2b2 Webclient`` link (or another port for another node).
Connect with the default credentials (``demo`` and ``prigen2017``), construct and run any query on the i2b2 demo data.

The demo data for MedCo needs a specific loading process covered on a separate guide, but if you have loaded them already,
you can run the ``SHRINE-MedCo Webclient`` from the index page (default credentials ``medcoshrineuser`` and ``prigen2017``),
select the MedCo plugin via the link on the top-right, and construct and run a query.

Another way to check is by accessing the ``SHRINE Dashboard`` from the index page (default credentials ``medcoadmin`` and ``prigen2017``).

