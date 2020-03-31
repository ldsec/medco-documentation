---
description: These pages explain how to deploy MedCo in different scenarios.
---

# Deployment

Each deployment scenario corresponds to a deployment profile, as described below. All these instructions use the deployment scripts from the [medco-deployment](https://github.com/ldsec/medco-deployment) repository.

**If you are new to MedCo…**

… and want to try to deploy the system on a single machine to test it, you should should follow the [Local Test Deployment](local-test-deployment.md) guide.

… and want to create or join a MedCo network for test purposes, you should follow the [Network Test Deployment](network-test-deployment.md) guide.

… and want to create or join a MedCo network in production, you should follow the [Network Production Deployment](network-production-deployment.md) guide.

… and want to develop around MedCo, you should follow the [Local Development Deployment](../../developers/local-development-deployment.md) guide.

## Deployment Profiles

A _deployment profile_ is composed of two things:

* a _compose profile_ in `medco-deployment/compose-profiles/<profile name>/`: docker-compose file and parameters like ports to expose, log level, etc.
* a _configuration profile_ in `medco-deployment/configuration-profiles/<profile name>/`: files mounted in the docker containers, containing the cryptographic keys, the certificates, etc.

Some profiles are provided by default, for development or testing purposes. Those should not be used in a production scenario with real data, as the private keys are set by default, thus not private. Other types of profiles must generated using the scripts in `medco-deployment/resources/profile-generation-scripts/<profile name>/`.

The different profiles are the following:

### _test-local-3nodes_ \([Local Test Deployment](local-test-deployment.md)\)

* for test on a single machine \(used by the MedCo live demo\)
* 3 nodes on any host
* using the latest release of the source codes
* no debug logging
* profile pre-generated

### _test-network_ \([Network Test Deployment](network-test-deployment.md)\)

* for test on several different hosts
* a single node on a host part of a MedCo network
* using the latest release of the source codes
* no debug logging
* profile must be generated prior to use with the provided scripts

### _prod-network_ \([Network Production Deployment](network-production-deployment.md)\)

* for a deployment in production
* a single node on a host part of a MedCo network
* using the latest release of the source codes
* no debug logging
* profile must be generated prior to use with the provided scripts

### _dev-local-3nodes_ \([Local Development Deployment](../../developers/local-development-deployment.md)\)

* for software development
* 3 nodes on the local host
* using development version of source codes
* debug logging enabled
* profile pre-generated

{% hint style="info" %}
The database is pre-loaded with some encrypted test data using a key that is pre-generated from the combination of all the participating nodes’ public keys. For the _test-network_ and _prod-network_ deployment profiles this data will not be correctly encrypted, since the public key of each node is generated independently, and, as such, the data must be re-loaded.
{% endhint %}

