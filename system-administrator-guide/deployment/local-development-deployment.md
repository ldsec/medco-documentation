# Local Development Deployment

Profile _dev-local-3nodes_

This deployment profile deploys 3 MedCo nodes on a single machine for development purposes. It is meant to be used only on your local machine, i.e. `localhost`. The tags of the docker images used are all _dev_, i.e. the ones built from the development version of the different source codes. They are available either through Docker Hub, or built locally.

### MedCo Stack Deployment \(except Glowing Bear\)

First step is to clone the `medco-deployment` repository with the correct branch. This example gets the data in the home directory of the current user, but that can be changed.

```text
$ cd ~
$ git clone -b dev https://github.com/ldsec/medco-deployment.git
```

Next step is to build the docker images:

```text
$ cd ~/medco-deployment/compose-profiles/dev-local-3nodes
$ docker-compose build
```

Note that instead of building the _dev_ docker images locally, it is possible to download them from Docker Hub by using `docker-compose pull`, but there is no guarantee on the current status of those images are they are automatically built.

Next step is to run the nodes. They will run simultaneously, and the logs of the running containers will maintain the console captive. No configuration changes are needed in this scenario before running the nodes. To run them:

```text
$ docker-compose up
```

Wait some time for the initialization of the containers to be done \(up to the message: _“i2b2-medco-srv… - Started x of y services \(z services are lazy, passive or on-demand\)”_\), this can take up to 10 minutes. For the subsequent runs, the startup will be faster.

### Glowing Bear Deployment

First step is to clone the `glowing-bear` repository with the correct branch.

```text
$ cd ~
$ git clone -b dev https://github.com/ldsec/glowing-bear-medco.git
```

Glowing Bear is deployed separately for development, as we use its convenient live development server:

```text
$ cd ~/glowing-bear-medco/deployment
$ docker-compose up dev-server
```

Note that the first run will take a significant time in order to build everything.

In order to stop the containers, simply hit `Ctrl+C` in all the active windows.

### Keycloak Configuration

Follow the instructions from [Keycloak Configuration](../configuration/keycloak-configuration.md) to be able to use Glowing Bear.

### Test the deployment

In order to test that the development deployment of MedCo is working, access Glowing Bear in your web browser at `http://localhost:4200` and use the credentials previously configured during the [Keycloak Configuration](../configuration/keycloak-configuration.md). If you are new to Glowing Bear you can watch the [Glowing Bear user interface walkthrough](https://glowingbear.app/) video.

By default MedCo loads a specific test data, refer to [Description of the default test data](https://medco.epfl.ch/documentation/developer/test_data_description.html#lbl-test-data-description) for expected results to queries. To load a dataset, follow the guide [Loading Data](../loading-data/). For reference, the database address \(host\) to use during loading is `localhost:5432` and the databases `i2b2medcosrv0`, `i2b2medcosrv1` and `i2b2medcosrv2`.

