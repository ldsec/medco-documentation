System Administrator Guide
==========================

..  toctree::
    :maxdepth: 3
    :includehidden:

    deployment_1_host
    deployment_multiple_hosts
    loading_data

This page explains how to deploy and configure MedCo in different scenarios.
The first scenario is for development purposes and explains how to deploy 3 nodes on a single server.
The second scenario is for test purposes and explains how to deploy 3 nodes on multiple separate servers.
Note that these two scenarios *should not be used in a production environment* (e.g, the private keys of the different nodes are public).

**Deployment profiles**

When building and running MedCo, a *compose-profile* and a *configuration-profile* must be created and used.
A *compose-profile* contains the Docker Compose file that starts a MedCo node. Configurations like ports to expose, log levels, etc. can be set up there.
A *configuration-profile* is a configuration folder shared by the containers and contains things such as keys and certificates.