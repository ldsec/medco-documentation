System Administrator Guide
==========================

..  toctree::
    :maxdepth: 3
    :includehidden:

    deployment_dev
    loading_data
    network_architecture

This page explains how to deploy and configure MedCo in different scenarios.
The first scenario is for development purposes and explains how to deploy 3 nodes on a single server.
The second scenario is for test purposes and explains how to deploy 3 nodes on multiple separate servers.
Both of those deployments come with some default test data.
Note that these two scenarios *should not be used in a production environment with real data* (e.g, the private keys of the different nodes are public, and the software is still experimental).


Deployment Profiles
-------------------

When building and running MedCo, a *compose-profile* and a *configuration-profile* must be created and used.
A *compose-profile* contains the Docker Compose file that starts a MedCo node.
Configurations like ports to expose, log levels, etc. can be set up there.
A *configuration-profile* is a configuration folder shared by the containers and contains things such as keys and certificates.
For development purposes, a profile running 3 nodes on a single machine is provided and can be used as is, see :ref:`lbl_deployment_dev`.
In other scenarios, the profiles must be created.


Specifications
--------------

We recommend the following specifications for running MedCo:

    - *Network Bandwidth*: >100 Mbps (ideal), >10 Mbps (minimum), symmetrical
    - *Ports Opening* and *IP Restrictions*: see :ref:`lbl_network_architecture`
    - *Hardware*
        - *CPU*: 8 cores (ideal), 4 cores (minimum)
        - *RAM*: >16 GB (ideal), >8GB (minimum)
        - *Storage*: dependent on data loaded, >100GB
    - *Software*
        - *OS*: Any flavor of Linux, physical or virtualized
        - *Softwares*: Docker & Docker-Compose
