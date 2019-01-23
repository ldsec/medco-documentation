System Administrator Guide
++++++++++++++++++++++++++

..  toctree::
    :maxdepth: 3
    :includehidden:

    deployment/index
    configuration/index
    loading_data/index
    network_architecture

This guide explains the deployment and configuration of MedCo instances.


Specifications
==============

We recommend the following specifications for running MedCo:

    - *Network Bandwidth*: >100 Mbps (ideal), >10 Mbps (minimum), symmetrical
    - *Ports Opening* and *IP Restrictions*: see :ref:`lbl_network_architecture`
    - *Hardware*

        - *CPU*: 8 cores (ideal), 4 cores (minimum)
        - *RAM*: >16 GB (ideal), >8GB (minimum)
        - *Storage*: dependent on data loaded, >100GB

    - *Software*

        - *OS*: Any flavor of Linux, physical or virtualized (tested with Ubuntu 16.04, 18.04, Fedora 29)
        - *Softwares*: Docker (version >= 18.03) & Docker-Compose (version >= 1.21), Git and Git-LFS
