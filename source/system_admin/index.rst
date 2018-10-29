System Administrator Guide
==========================

This page explains how to deploy and configure MedCo in different scenarios.
The first scenario is for development purposes and explains how to deploy 3 nodes on a single server.
The second scenario is for test purposes and explains how to deploy 3 nodes on separates servers.
Note that these two scenarios *should not be used in a production environment*: the private keys of the different nodes are public.

**Deployment profiles**

When building and running MedCo, a *compose-profile* and a *configuration-profile* must be created and used.
A *compose-profile* contains the Docker Compose file that starts a MedCo node. Configurations like ports to expose, log levels, etc. can be set up there.
A *configuration-profile* is a configuration folder shared by the containers and contains things such as keys and certificates.

.. _lbl_deploy_single_server:

Deploying MedCo on a Single Server
----------------------------------
This short guide will show you how to deploy 3 nodes of the full MedCo stack on a single machine with the help of Docker and Docker-Compose.
Any kind of not too old Linux flavor should work, but it has only be tested on the following configuration:

- Operating System: Ubuntu 16.04 LTS, assumed to be freshly installed and up to date.
- Pre-requisite software: *git* (the rest of the dependencies will be automatically installed with a script).

First step is to clone the ``medco-deployment``, ``IRCT`` and ``glowing-bear`` repositories (with the correct branch) and to execute the script that will install the dependencies on your machine.
Among others, it will install Docker 18.06.0-ce and Docker-Compose 1.23.0.

.. code-block:: bash

    $ cd ~
    $ git clone https://github.com/lca1/medco-deployment.git
    $ git clone -b fork/thehyve https://github.com/lca1/IRCT.git
    $ git clone -b picsure https://github.com/lca1/glowing-bear.git
    $ bash ~/medco-deployment/resources/utility-scripts/ubuntu_prereqs_setup.sh

Next step is to build the docker images.
In this specific case (i.e. 3 nodes running on a single machine) you can use the provided compose and configuration profiles, called ``dev-3nodes-samehost``.
As the name indicates, it was mainly done for development purposes and runs 3 nodes on a single host machine.

This command will build all 3 nodes from scratch:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/dev-3nodes-1host
    $ docker-compose -f docker-compose.yml build

Next we need to build the docker images for IRCT and glowing-bear:  

.. code-block:: bash

    $ cd ~/IRCT/deployments
    $ docker-compose -f docker-compose.medco.dev-3nodes-1host.yml build

.. code-block:: bash

    $ cd
    $ docker-compose -f build

Next step is to run the nodes. They need to be running simultaneously, and the logs of the running containers will maintain the console captive.
For this reason it is recommended to use *screen* to run them. Use ``screen -dRR`` to start a new screen session.
``Ctrl+A-C`` will create a new window: create at least 3 of them. ``Ctrl+A-P`` and ``Ctrl+A-N`` allow to navigate between the windows.
Hit simply ``Ctrl+D`` to close the current window. Use ``Ctrl+A-D`` to detach from the screen instance. Once detached you are back in the normal console
and can simply run again ``screen -dRR`` to attach to the running screen session.

Run the all nodes:

.. code-block:: bash

    $ docker-compose -f docker-compose.yml up

In a separate *screen* window run the IRCT container:

.. code-block:: bash

    $ docker-compose -f docker-compose.medco.dev-3nodes-1host.yml up

And in another separate window run the glowing-bear container:

.. code-block:: bash

    $ docker-compose -f xxx up

The first time each of the node runs, the database will be initialized with the structure and the i2b2 demo data,
it will take a few minutes so do not interrupt this loading!
The next times the nodes are ran, they take 1-2 minutes to be up and running. In order to stop all the nodes,
simply hit ``Ctrl+C`` in all the active windows. If you wish to stop a single node, just manually stop each node's containers.

.. code-block:: bash

    $ docker-compose -f xxx stop dev-3nodes-1host_i2b2-medco-srvX dev-3nodes-1host_unlynx-srv1X dev-3nodes-1host_web-srvX 

**Important note about the ports used when running several nodes a single host**

Since they are running on the same host, the ports used for the different services had to be adapted.
The modification follows the following logic: if the port is specified as being ``80`` on the documentation,
the port exposed on the host for the first node will be ``82``, for the second node ``84``, and for the third ``86``.
That is, they are incremented by 2 for every node.

**Testing that the nodes are working**

In order to test that a *single node* is working, you can access the index page at ``<your_server_address>:82`` and
click on the .
Connect with the default credentials ( and ), construct and run any query on the i2b2 demo data.

The demo data for MedCo needs a specific loading process covered on a separate guide, but if you have loaded them already,
you can run the .

.. _lbl_deploy_multiple_servers:

Deploying MedCo on Different Servers 
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

Loading Data
------------

The current version offers two different loading alternatives: (v0) loading of genomic data; and (v1) loading of encrypted i2b2 data.

First get the repository containing the MedCo loader software, which already contains some test data for you to work with. 
Currently there are two different datasets: a genomic dataset (tcga_cbio publicly available in `cbio portal <http://www.cbioportal.org/>`_) and a protected version of the `i2b2 demodata <https://www.i2b2.org/software/repository.html?t=demo&p=15>`_.
Future releases of this software will allow for other arbitrary data sources, given that they follow a specific structure (e.g. BAM format).

.. code-block:: bash

    $ cd ~
    $ git clone https://github.com/lca1/medco-loader.git

**Building Application**

There are two different ways to build the medco-loader application. If Go and the necessary requirements (libraries) are installed in your machine:

.. code-block:: bash

    cd ~/medco-loader/app/
    go build -o medco-loader *.go

or simply run the following bash script,

.. code-block:: bash

    cd ~/medco-loader/app/
    bash compileLinux.sh

If do not possess the environment to build go applications you can use our docker container to get the executable.

.. code-block:: bash

    cd ~/medco-loader/docker/
    bash run.sh

v0 (Genomic Data)
+++++++++++++++++

v0 expects an ontology, as well as, mutation and clinical data. As the ontology data you must use ``data/genomic/tcga_cbio/clinical_data.csv`` and ``data/genomic/tcga_cbio/mutation_data.csv``. 
As clinical data you can keep using the same two files or a subset of the data (e.g. 8_clinical_data.csv). More information about how to generate sample datafiles can be found below. 
All the data is encrypted and 'deterministically tagged' and it is compliant with the MedCo data model.

**To run v0 (example).**

.. code-block:: bash

    ./medco-loader -debug 2 v0 \
    --group group.toml --entryPointIdx 0 \
    --ont_clinical ../data/genomic/tcga_cbio/8_clinical_data.csv \
    --sen ../data/genomic/sensitive.txt  \
    --ont_genomic ../data/genomic/tcga_cbio/8_mutation_data.csv  \
    --clinical ../data/genomic/tcga_cbio/8_clinical_data.csv \
    --genomic ../data/genomic/tcga_cbio/8_mutation_data.csv \
    --output ../data/genomic/ \
    --dbHost localhost --dbPort 5432 --dbName i2b2medcosrv0 \ 
    --dbUser i2b2 --dbPassword i2b2

Explanation of the arguments:

.. code-block:: bash

    NAME:
        medco-loader v0 - Load genomic data (e.g. tcga_bio dataset)

    USAGE:
        medco-loader v0 [command options] [arguments...]

    OPTIONS:
        --group value, -g value               UnLynx group definition file
        --entryPointIdx value, --entry value  Index (relative to the group definition file) of the collective authority server to load the data (default: 0)
        --sensitive value, --sen value        File containing a list of sensitive concepts
        --dbHost value, --dbH value           Database hostname
        --dbPort value, --dbP value           Database port (default: 0)
        --dbName value, --dbN value           Database name
        --dbUser value, --dbU value           Database user
        --dbPassword value, --dbPw value      Database password
        --ont_clinical value, --oc value      Clinical ontology to load (default: "../../data/genomic/tcga_cbio/clinical_data.csv")
        --ont_genomic value, --og value       Genomic ontology to load (default: "../../data/genomic/tcga_cbio/mutation_data.csv")
        --clinical value, --cl value          Clinical file to load (default: "../../data/genomic/tcga_cbio/clinical_data.csv")
        --genomic value, --gen value          Genomic file to load (default: "../../data/genomic/tcga_cbio/mutation_data.csv")
        --output value, -o value              Output path to the .csv files (default: "../data/genomic/")

For more help simply type

.. code-block:: bash

    ./medco-loader v0 -help

If you followed the 3-node deployment in a single host machine you can simply execute:

.. code-block:: bash

    cd ~/medco-loader/app/
    bash testGenomic.sh

**Data Manipulation**

Inside /data/scripts/ you can find a small python application to extract (or replicate) data out of the original tcga_cbio dataset. 
You can decide which patients do you want to consider for you 'new' dataset or simply randomly pick a sample.

v1 (I2B2 Demodata)
++++++++++++++++++

v1 expects an already existing i2b2 database (.csv style format) that will be converted in a way that is compliant with the MedCo data model. 
This involves encrypting and 'deterministically tagging' some of the data.

List of input ('original') files:

.. code-block:: bash

    -> all i2b2metadata files(e.g. i2b2.csv)            
    -> dummy_to_patient.csv*
    -> patient_dimension.csv
    -> visit_dimension.csv
    -> concept_dimension.csv
    -> modifier_dimension.csv
    -> observation_fact.csv*
    *obtained by running the dummy generation script

**Dummy Generation**

-----------------------------------------------------------------------------

**Important Notice**

The test data (``data/i2b2/original``) in the repository as been pre-masked so you do not need to actually run this dummy generation step.

-----------------------------------------------------------------------------

Before running the loader we need to generate random dummy entries to prevent frequency attacks. 
For that we have to generate a new observation_fact.csv from the original one and new set of patients (dummy_to_patient.csv). 
For more information on how this dummy generation is done please refer to /data/scripts/import-tool/report/report.pdf.

If you have Jupyter Notebook with python enabled simply run /data/scripts/import-tool/using_clustering.ipynb. 
If not, from the command line you can convert a notebook to python with this command:

.. code-block:: bash

    ipython nbconvert --to python <YourNotebook>.ipynb

You may have to install the python mistune package:

.. code-block:: bash

    sudo pip install mistune

**To run v1 (example).**

.. code-block:: bash

    ./medco-loader -debug 2 v1 \
    --group group.toml --entry 0 \
    --sen ../data/i2b2/sensitive.txt\ 
    --files ../data/i2b2/files.toml \
    --dbHost localhost  --dbPort 5432 --dbName i2b2medcosrv0 \
    --dbUser i2b2 --dbPassword i2b2

.. code-block:: bash

    NAME:
        medco-loader v1 - Convert existing i2b2 data model

    USAGE:
        medco-loader v1 [command options] [arguments...]

    OPTIONS:
        --group value, -g value               UnLynx group definition file
        --entryPointIdx value, --entry value  Index (relative to the group definition file) of the collective authority server to load the data (default: 0)
        --sensitive value, --sen value        File containing a list of sensitive concepts
        --dbHost value, --dbH value           Database hostname
        --dbPort value, --dbP value           Database port (default: 0)
        --dbName value, --dbN value           Database name
        --dbUser value, --dbU value           Database user
        --dbPassword value, --dbPw value      Database password
        --files value, -f value               Configuration toml with the path of the all the necessary i2b2 files (default: "files.toml")
        --empty, -e                           Empty patient and visit dimension tables (y/n)

For more help simply type

.. code-block:: bash

    ./medco-loader v1 -help

If you followed the 3-node deployment in a single host machine you can simply execute:

.. code-block:: bash

    cd ~/medco-loader/app/
    bash testI2B2.sh

