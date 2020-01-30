# Local Test Deployment

Profile _test-local-3nodes_

This test profile deploys 3 MedCo nodes on a single machine for test purposes. It can be used either on your local machine, or any other machine to which you have access. The version of the docker images used are the latest released versions. This profile is for example used for the [MedCo public demo](https://medco-demo.epfl.ch/).

### MedCo Stack Deployment

First step is to get the MedCo Deployment latest release.

```text
$ cd ~
$ wget https://github.com/ldsec/medco-deployment/archive/v0.2.1-1.tar.gz
$ tar xvzf v0.2.1-1.tar.gz
$ mv medco-deployment-0.2.1-1 medco-deployment
```

Next step is to download the docker images:

```text
$ cd ~/medco-deployment/compose-profiles/test-local-3nodes
$ docker-compose pull
```

The default configuration of the deployment is suitable if the stack is deployed on your local host, and if you do not need to modify the default passwords. If so, edit the file `~/medco-deployment/compose-profiles/test-local-3nodes/.env` to reflect your configuration. For example:

```text
MEDCO_NODE_HOST=medco-demo.epfl.ch
HTTP_SCHEME=https
POSTGRES_PASSWORD=postgres1
PGADMIN_PASSWORD=admin
KEYCLOAK_PASSWORD=keycloak
I2B2_WILDFLY_PASSWORD=admin
I2B2_SERVICE_PASSWORD=pFjy3EjDVwLfT2rB9xkK
I2B2_USER_PASSWORD=demouser
```

`MEDCO_NODE_URL` should be the fully qualified domain name of the host, `HTTP_SCHEME` should be `http` or `https`. The other fields control the default passwords for the various services running. Note that setting the passwords that way works only on the first deployment. If the passwords need to be updated later, you should use the specific component way of modifying password.

Follow [HTTPS Configuration](../configuration/https-configuration.md) to set up the certificates needed for HTTPS. If you are deploying on another host than the local host without HTTPS take note of the following: [Disabling HTTPS requirement for external connections](../configuration/keycloak-configuration.md#disabling-https-requirement-for-external-connections).

Final step is to run the nodes, all three will run simultaneously:

```text
$ docker-compose up
```

Wait some time for the initialization of the containers to be done \(up to the message: _“i2b2-medco-srv… - Started x of y services \(z services are lazy, passive or on-demand\)”_\), this can take up to 10 minutes. For the subsequent runs, the startup will be faster. In order to stop the containers, hit `Ctrl+C` in the active window.

You can use the command `docker-compose up -d` instead to run MedCo in the background and thus not keeping the console captive. In that case use `docker-compose stop` to stop the containers.

### Keycloak Configuration

Follow the instructions from [Keycloak Configuration](../configuration/keycloak-configuration.md) to be able to use Glowing Bear.

### Test the deployment

In order to test that the local test deployment of MedCo is working, access Glowing Bear in your web browser at `http(s)://<domain name>` and use the credentials previously configured during the [Keycloak Configuration](../configuration/keycloak-configuration.md). If you are new to Glowing Bear you can watch the [Glowing Bear user interface walkthrough](https://glowingbear.app/) video.

By default MedCo loads a specific test data, refer to  [Description of the default test data](../../developer-guide/description-of-the-default-test-data.md) for expected results to queries. To load a dataset, follow the guide [Loading Data](../loading-data/). For reference, the database address \(host\) to use during loading is `<domain name>:5432` and the databases `i2b2medcosrv0`, `i2b2medcosrv1` and `i2b2medcosrv2`.

