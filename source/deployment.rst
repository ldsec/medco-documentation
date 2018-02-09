Deployment Documentation
========================

**Subpages**

..  toctree::
    :maxdepth: 1

    deployment/deployed_description


This page explains how to deploy and configure MedCo in different scenarios.
The first scenario is for development purposes and allows to deploy 3 nodes on a single server.
The second scenario is for test purposes and allows to deploy 3 nodes on separates servers.
Note that these two scenarios *should not be used in a production environment*: the private keys of the different nodes are public.

**Deployment profiles**

When building and running MedCo, a *compose-profile* and a *configuration-profile* must be created and used.
A *compose-profile* contains the Docker Compose file that starts a MedCo node. Configurations like ports to expose, log levels, etc. can be set up there.
A *configuration-profile* is a configuration folder shared by the containers and contains things such as keys and certificates, see :ref:`lbl_config_folder`.


.. _lbl_deploy_single_server:

Deploying MedCo on a Single Server (For Development)
----------------------------------------------------
This short guide will show you how to deploy 3 nodes of the full MedCo stack on a single machine with the help of Docker and Docker-Compose.
Any kind of not too old Linux flavor should work, but it has only be tested on the following configuration:

- Operating System: Ubuntu 14.04.5 LTS, assumed to be freshly installed and up to date.
- Pre-requisite software: *git* (the rest of the dependencies will be automatically installed with a script).

First step is to clone the ``medco-deployment`` repository and to execute the script that will install the dependencies on your machine.
Among others, it will install Docker 17.12.0-ce and Docker-Compose 1.14.0.

.. code-block:: bash

    $ cd ~
    $ git clone https://c4science.ch/source/medco-deployment.git
    $ bash ~/medco-deployment/resources/utility-scripts/ubuntu_prereqs_setup.sh

Next step is to build the docker images. They will be built from source, for this reason the very first build might
take a lot of time depending on the perfomance of your machine (up to 2 hours on a standard laptop, around 20 minutes on a powerful server).
In this specific case (i.e. 3 nodes running on a single machine) you can use the provided compose and configuration profiles, called ``dev-3nodes-samehost``.
As it name indicates, it is for development purposes, runs 3 nodes on a single server.

This command will build the first node from scratch:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/dev-3nodes-samehost
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
simply hit ``Ctrl+C`` in the window where the node is active.

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

**Trusting the CA in your web browser**

The file ``cacert.pem`` is the certificate of the CA, simply import it in your web browser in order to not have HTTPS
warning messages when browsing the MedCo web pages.

.. _lbl_deploy_different_servers_dev:

Deploying MedCo on Different Servers (For Development)
------------------------------------------------------
This short guide will show you how to generate a working configuration in order to deploy 3 nodes of the full MedCo stack
on a separate servers machine with the help of Docker, Docker-Compose and a script.

Use the previous guide :ref:`lbl_deploy_single_server` to clone the ``medco-deployment`` and install the required dependencies on your system.
Before building the Docker images it is needed to generate the configuration profile, this can be done on your machine or on one of the servers that will serve a MedCo node.


**Generating the configuration profile**

Execute the tool with the properly constructed arguments:

.. code-block:: bash

    $ cd ~/medco-deployment/resources/config-generation-tool
    $ bash generate-dev-configuration-profile.sh test-3nodes somepassword server1.domain.com 1.1.1.1 server2.domain.com 2.2.2.2 server3.domain.com 3.3.3.3

Explanation of the arguments:

- ``test-3nodes``: name of the configuration profile, the folders ``compose-profiles/test-3nodes`` and ``configuration-profiles/test-3nodes`` will be created
- ``somepassword``: password used to encrypt the keystores and the CA certificate generated
- ``serverX.domain.com``: the DNS name of the server number X
- ``A.B.C.D``: the IP address of the server number X

The tool will be executed and several questions will be asked, let's go through them.

.. code-block:: console

    CA certificate filename (or enter to create)
    <leave empty>

Leave empty to force the creation of a new certificate authority.


.. code-block:: console

    Enter PEM pass phrase:somepassword
    Verifying - Enter PEM pass phrase:somepassword

This is the password used to encrypted the private key of the certificate authority: you can use the same as specified
in the arguments of called script (for simplicity).


.. code-block:: console

    Country Name (2 letter code) [XX]:CH
    State or Province Name (full name) []:VD
    Locality Name (eg, city) [Default City]:Lausanne
    Organization Name (eg, company) [Default Company Ltd]:EPFL
    Organizational Unit Name (eg, section) []:LCA1
    Common Name (eg, your name or your server's hostname) []:MedCo
    Email Address []:

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:
    An optional company name []:
    Using configuration from /.../medco-deployment/resources/config-generation-tool/openssl.cnf
    Enter pass phrase for /.../medco-deployment/resources/config-generation-tool/CA/private/./cakey.pem:somepassword

These are the information that will be embedded in the certificate of the certificate authority.
At the end input the password used to encrypt the private key of the CA.


.. code-block:: none

    ###0### Signing it with the CA
    Using configuration from /.../medco-deployment/resources/config-generation-tool/openssl.cnf
    Enter pass phrase for ./CA/private/cakey.pem:somepassword
    Check that the request matches the signature
    Signature ok
    Certificate Details:
            Serial Number:
                c9:90:07:32:99:e9:02:58
            Validity
                Not Before: Jan 23 17:29:03 2018 GMT
                Not After : Jan 23 17:29:03 2019 GMT
            Subject:
                countryName               = CH
                stateOrProvinceName       = VD
                localityName              = Lausanne
                organizationName          = EPFL
                organizationalUnitName    = LCA1
                commonName                = server1.domain.com
            X509v3 extensions:
                X509v3 Basic Constraints:
                    CA:FALSE
                X509v3 Subject Alternative Name:
                    IP Address:1.1.1.1, DNS:server1.domain.com
                X509v3 Subject Key Identifier:
                    C1:E2:6D:08:14:D7:76:4D:CF:7D:43:79:53:1F:C8:B0:45:91:71:9C
    Certificate is to be certified until Jan 23 17:29:03 2019 GMT (365 days)
    Sign the certificate? [y/n]:y
    1 out of 1 certificate requests certified, commit? [y/n]y

Here input again the password and validate with ``y`` twice to confirm the signature of the certificate of the node by the CA.
Repeat this operation for as many nodes as you have (3 in this example), your configuration profile has been generated.


**Deploying the nodes**

Now that the configuration profile ``test-3nodes`` is generated, repeat the operation of cloning the ``medco-deployment`` repository
and installing the dependencies on all the servers that will be MedCo nodes.
Next copy on those servers the configuration profile, that is the 2 folders ``compose-profiles/test-3nodes`` and ``configuration-profiles/test-3nodes``.

From there the  next steps are very similar to the single server scenario, build and run the nodes on all the servers.
On server number 0:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-3nodes
    $ docker-compose -f docker-compose-srv0.yml build
    $ docker-compose -f docker-compose-srv0.yml up

On server number 1:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-3nodes
    $ docker-compose -f docker-compose-srv1.yml build
    $ docker-compose -f docker-compose-srv1.yml up

On server number 2:

.. code-block:: bash

    $ cd ~/medco-deployment/compose-profiles/test-3nodes
    $ docker-compose -f docker-compose-srv2.yml build
    $ docker-compose -f docker-compose-srv2.yml up



Deploying MedCo on Different Servers (For Production)
-----------------------------------------------------

This short guide will show you how to generate a working configuration in order to deploy a node of the full MedCo stack
within a MedCo network of an arbitrary size, with the help of Docker, Docker-Compose and scripts.

Use the previous guide :ref:`lbl_deploy_single_server` to clone the ``medco-deployment`` and install the required dependencies on your system.
It is first needed to generate the configuration profiles indepentently for all the nodes, which can be done in several steps.
A prerequisite to this step is that the different nodes must agree on their node index number, i.e. a node will be index 0,
another index 1, and so on...


**Generating the configuration profile of a node**

Execute the first step with the properly constructed arguments to initialize the profiles and create the certificate authority
(or import your own by inspecting how the script works).

.. code-block:: bash

    $ cd ~/medco-deployment/resources/config-generation-tool/generate-prod-configuration-profile
    $ bash step1.sh test-prod-3nodes nodeindex somepassword serverX.domain.com

Explanation of the arguments:

- ``test-prod-3nodes``: name of the configuration profile, the folders ``compose-profiles/test-prod-3nodes`` and ``configuration-profiles/test-prod-3nodes`` will be created
- ``nodeindex``: index number of the node for which the configuration is currently being generated
- ``somepassword``: password used to encrypt the keystores and the CA certificate generated
- ``serverX.domain.com``: the DNS name of the server

The tool will be executed and several questions will be asked, use the beginning of the previous guide :ref:`lbl_deploy_different_servers_dev`
to follow the creation of the certificate authority.


Execute then the second step to generate the key pair for the node
(or import your own by inspecting how the script works).

.. code-block:: bash

    $ bash step2.sh test-prod-3nodes nodeindex somepassword serverX.domain.com A.B.C.D

Explanation of the arguments:

- ``A.B.C.D``: the IP address of the server number X


The third step to generate the certificate of the node
(or import your own by inspecting how the script works).

.. code-block:: bash

    $ bash step3.sh test-prod-3nodes nodeindex somepassword serverX.domain.com A.B.C.D

The tool will be executed and several questions will be asked, use the end of the previous guide :ref:`lbl_deploy_different_servers_dev`
to follow the signature of the certificate.


The fourth step to generate the unlynx keys and package the files to share with other nodes.

.. code-block:: bash

    $ bash step4.sh test-prod-3nodes nodeindex A.B.C.D

After this step an archive ``srvX-publicdata.tar.gz`` will be generated.
Share this archive with the responsible of all the other nodes, and gather the archives of the other nodes before continuing to step 5.


The fifth and final step to aggregate the files

.. code-block:: bash

    $ bash step5.sh test-prod-3nodes nodeindex somepassword srv0-publicdata.tar.gz srv1-publicdata.tar.gz...

Explanation of the arguments:

- ``srvX-publicdata.tar.gz``: the archives shared by the other nodes

The MedCo node is now ready to be built and ran using Docker-Compose, follow the previous guide :ref:`lbl_deploy_different_servers_dev`
to do so.


Loading the demo data of a node
-------------------------------

Loading the demo data is a 2-steps process. First step is to encrypt and load all of the clinical and genomic data in the i2b2
database, and second is to load all of the genomic annotations.

First get the archive containing all of the MedCo v0.1 demo data (file ``medco_v0.1_demo_data.tar.gz`` to be asked on
the ``medco-dev`` email list) and extract it in the folder of your choice, say ``~/medco_v0.1_demo_data/``.
Then on the node adapt and execute these commands (example for node 0, configuration profile ``test-prod-3nodes``):


.. code-block:: bash

    $ cd ~/medco_v0.1_demo_data/
    $ ~/medco-deployment/configuration-profiles/test-prod-3nodes/unlynxMedCo loader \
    --file ~/medco-deployment/configuration-profiles/test-prod-3nodes/group.toml --entryPointIdx 0 \
    --ont_clinical ./data_clinical_skcm_broad.csv --sensitive PRIMARY_TUMOR_LOCALIZATION_TYPE --sensitive CANCER_TYPE_DETAILED \
    --ont_genomic ./data_mutations_extended_skcm_broad.csv --clinical ./data_clinical_skcm_broad_clear_i2b2_part1_encodingOK.txt \
    --genomic ./data_mutations_extended_skcm_broad_clear_i2b2_part1_encodingOK.txt --dbHost localhost \
    --dbPort 5432 --dbName i2b2medco --dbUser postgres --dbPassword prigen2017

Explanation of the arguments:

- ``file``: public key of the collective authority
- ``entryPointIdx``: the pre-agreed node number to which the data is being loaded
- ``ont_clinical``: clinical dataset file used to populate the ontology
- ``sensitive``: fields from the clinical dataset file considered sensitive (several allowed)
- ``ont_genomic``: genomic dataset file used to populate the ontology (the annotations)
- ``clinical``: clinical dataset with the data to load
- ``genomic``: genomic dataset with the data to load
- ``dbHost``: postgresql host in which to load the data
- ``dbPort``: postgresql port
- ``dbName``: postgresql database name
- ``dbUser``: postgresql user for login
- ``dbPassword``: postgresql password for login


The second step will load the annotations in a way that the webclient will be able to query them:

.. code-block:: bash

    $ PGPASSWORD="pFjy3EjDVwLfT2rB9xkK" psql -U genomic_annotations -d i2b2medco -h localhost -p 5432 -a -f sqlAnnotations_all.sql

Explanation of the arguments:

- ``PGPASSWORD``: postgresql password
- ``U``: postgresql user
- ``d``: postgresql database
- ``h``: postgresql host
- ``p``: postgresql port
- 