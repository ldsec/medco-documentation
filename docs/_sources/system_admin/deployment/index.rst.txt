Deployment
==========

..  toctree::
    :maxdepth: 3
    :includehidden:

    test-local-3nodes
    test-network
    dev-local-3nodes

Those pages explain how to deploy MedCo in different scenarios.
Each deployment scenario corresponds to a deployment profile, as described below.
All those instructions use the deployment scripts from the :ref:`lbl_component_medco-deployment` component.

**If you are new to MedCo...**

... and want to try to deploy the system on a single machine to test it, you should should follow the :ref:`lbl_deployment_test-local-3nodes` guide.

... and want to create or join a MedCo network, you should follow the :ref:`lbl_deployment_test-network` guide.

... and want to develop around MedCo, you should follow the :ref:`lbl_deployment_dev-local-3nodes` guide.


Deployment Profiles
-------------------

A *deployment profile* is composed of two things:

- a *compose profile* in ``compose-profiles/<profile name>/``: docker-compose file and parameters like ports to expose, log level, etc.
- a *configuration profile* in ``configuration-profiles/<profile name>/``: files mounted in the docker containers, containing the cryptographic keys, the certificates, etc.

Some profiles are provided by default, for development or testing purposes.
Those should not be used in a production scenario with real data, as the private keys are set by default, thus not private.
Other types of profiles must generated using the scripts in ``resources/profile-generation-scripts/<profile name>/``.

The different profiles are the following:

- *test-local-3nodes* (:ref:`lbl_deployment_test-local-3nodes`)

    - for test on a single machine (used by the `MedCo live demo <https://medco-demo.epfl.ch>`_)
    - 3 nodes on any host
    - using the latest release of the source codes
    - no debug logging
    - profile pre-generated

- *test-network* (:ref:`lbl_deployment_test-network`)

    - for test on several different hosts
    - a single node on a host part of a MedCo network
    - using the latest release of the source codes
    - no debug logging
    - profile must be generated prior to use with the provided scripts

- *dev-local-3nodes* (:ref:`lbl_deployment_dev-local-3nodes`)

    - for software development
    - 3 nodes on the local host
    - using development version of source codes
    - debug logging enabled
    - profile pre-generated

At the very first deployment the database is loaded with some test encrypted data, using the key of the pre-generated profiles.
This means that this test data will not work with the profile *test-network*, but only with *dev-local-3nodes* and *test-local-3nodes*.
