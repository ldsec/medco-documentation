---
description: Deployment profile dev-local-3nodes.
---

# Local Development Deployment

{% hint style="danger" %}
This deployment profile comes with default pre-generated keys and password. It is not meant to contain any real data nor be used in production. If you wish to do so, use instead the [Network Deployment \(network\)](../system-administrators/deployment/network-deployment.md) deployment profile.
{% endhint %}

This deployment profile deploys 3 MedCo nodes on a single machine for development purposes. It is meant to be used only on your local machine, i.e. `localhost`. The tags of the docker images used are all _dev_, i.e. the ones built from the development version of the different source codes. They are available either through Docker Hub, or built locally from the sources of each component.

## MedCo Stack Deployment \(except Glowing Bear\)

First step is to clone the `medco` repository with the correct branch. This example gets the data in the home directory of the current user, but that can be of course changed.

```bash
cd ~
git clone -b dev https://github.com/ldsec/medco.git
```

Next step is to build the docker images defined in the `medco` repository:

```bash
cd ~/medco/deployments/dev-local-3nodes
make build
```

{% hint style="info" %}
Note that this will build the docker images defined locally. Because those are development versions, there is no guarantee that they will work at any point in time.
{% endhint %}

Next step is to run the nodes. They will run simultaneously, and the logs of the running containers will maintain the console captive. No configuration changes are needed in this scenario before running the nodes. To run them:

```text
$ make up
```

Wait some time for the initialization of the containers to be done \(up to the message: _“i2b2-medco-srv… - Started x of y services \(z services are lazy, passive or on-demand\)”_\), this can take up to 10 minutes. For the subsequent runs, the startup will be faster.

### Deploy new docker image of a running service

In order to deploy new code in the running deployment, it is enough to stop and start again the running container\(s\). Example:

```bash
make stop
make up
```

{% hint style="info" %}
To confirm that a new version of the image has been deployed, Docker will output in the console "Recreating container ...".
{% endhint %}

## Glowing Bear Deployment

First step is to clone the `glowing-bear-medco` repository with the correct branch.

```bash
cd ~
git clone -b dev https://github.com/ldsec/glowing-bear-medco.git
```

Glowing Bear is deployed separately for development, as we use its convenient live development server:

```bash
cd ~/glowing-bear-medco/deployment
./dev-server.sh
```

Note that the first run will take a significant time in order to build everything.

In order to stop the containers, simply hit `Ctrl+C` in all the active windows.

## Test the deployment

In order to test that the development deployment of MedCo is working, access Glowing Bear in your web browser at `http://localhost:4200/glowing-bear/` and use the default credentials specified in [Keycloak user management](../system-administrators/deployment/configuration/keycloak.md#user-management). If you are new to Glowing Bear you can watch the [Glowing Bear user interface walkthrough](https://glowingbear.app/) video. You can also use the [CLI client](../system-administrators/cli.md) to perform tests.

By default MedCo loads a specific test data, refer to [Description of the default test data](https://medco.epfl.ch/documentation/developer/test_data_description.html#lbl-test-data-description) for expected results to queries. To load a dataset, follow the guide [Loading Data](../system-administrators/data-loading/). To load some additional test data by performing a simple data loading you can execute the following:

```bash
make load_test_data
```

