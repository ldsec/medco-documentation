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


Deploying MedCo on Different Servers
------------------------------------
This short guide will show you how to generate a working configuration in order to deploy 3 nodes of the full MedCo stack
on a separate servers machine with the help of Docker, Docker-Compose and a script.

Use the previous guide :ref:`lbl_deploy_single_server` to clone the ``medco-deployment`` and install the required dependencies on your system.
Before building the Docker images it is needed to generate the configuration profile, this can be done on your machine or on one of the servers that will serve a MedCo node.


**Generating the configuration profile**

Execute the tool with the properly constructed arguments:

.. code-block:: bash

    $ cd medco-deployment/resources/config-generation-tool
    $ bash generate-configuration-profile.sh test-3nodes somepassword server1.domain.com 1.1.1.1 server2.domain.com 2.2.2.2 server3.domain.com 3.3.3.3

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

    $ cd medco-deployment/compose-profiles/test-3nodes
    $ docker-compose -f docker-compose-srv0.yml build
    $ docker-compose -f docker-compose-srv0.yml up

On server number 1:

.. code-block:: bash

    $ cd medco-deployment/compose-profiles/test-3nodes
    $ docker-compose -f docker-compose-srv1.yml build
    $ docker-compose -f docker-compose-srv1.yml up

On server number 2:

.. code-block:: bash

    $ cd medco-deployment/compose-profiles/test-3nodes
    $ docker-compose -f docker-compose-srv2.yml build
    $ docker-compose -f docker-compose-srv2.yml up
