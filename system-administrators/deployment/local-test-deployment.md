---
description: Deployment of profile test-local-3nodes.
---

# Local Test Deployment

{% hint style="danger" %}
This deployment profile comes with default pre-generated keys and default passwords. It is not meant to contain any real data nor be used in production. If you wish to do so, use instead the [Network Production Deployment \(prod-network\)](network-production-deployment.md) deployment profile.
{% endhint %}

This test profile deploys 3 MedCo nodes on a single machine for test purposes. It can be used either on your local machine, or any other machine to which you have access. The version of the docker images used are the latest released versions. This profile is for example used for the [MedCo public demo](https://medco-demo.epfl.ch/).

## MedCo Stack Deployment

First step is to get the MedCo Deployment latest release and download the docker images. Adapt `${MEDCO_SETUP_DIR}` to where you wish to install MedCo.

```bash
export MEDCO_SETUP_DIR=~/medco-deployment MEDCO_SETUP_VER=0.3.0
wget https://github.com/ldsec/medco-deployment/archive/v${MEDCO_SETUP_VER}.tar.gz
tar xvzf v${MEDCO_SETUP_VER}.tar.gz
mv medco-deployment-${MEDCO_SETUP_VER} "${MEDCO_SETUP_DIR}"
cd "${MEDCO_SETUP_DIR}/compose-profiles/test-local-3nodes"
docker-compose -f docker-compose.yml -f docker-compose.tools.yml pull
```

The default configuration of the deployment is suitable if the stack is deployed on your local host, and if you do not need to modify the default passwords. If so, edit the file `${MEDCO_SETUP_DIR}/compose-profiles/test-local-3nodes/.env` to reflect your configuration. For example:

```bash
MEDCO_NODE_HOST=medco-demo.epfl.ch
MEDCO_NODE_HTTP_SCHEME=https
POSTGRES_PASSWORD=postgres_password
PGADMIN_PASSWORD=pgadmin_password
KEYCLOAK_PASSWORD=keycloak_password
I2B2_WILDFLY_PASSWORD=i2b2_wildfly_password
I2B2_SERVICE_PASSWORD=i2b2_service_password
I2B2_USER_PASSWORD=i2b2_user_password
```

`MEDCO_NODE_HOST` should be the fully qualified domain name of the host, `MEDCO_NODE_HTTP_SCHEME` should be `http` or `https`. The other fields control the default passwords for the various services running. Note that setting the passwords that way works only on the first deployment. If the passwords need to be updated later, you should use the specific component way of modifying password.

{% hint style="warning" %}
If you enable HTTPS, follow [HTTPS Configuration](configuration/https-configuration.md) to set up the needed certificates.
{% endhint %}

Final step is to run the nodes, all three will run simultaneously:

```bash
cd "${MEDCO_SETUP_DIR}/compose-profiles/test-local-3nodes"
docker-compose up
```

Wait some time for the initialization of the containers to be done \(up to the message: _“i2b2-medco-srv… - Started x of y services \(z services are lazy, passive or on-demand\)”_\), this can take up to 10 minutes. For the subsequent runs, the startup will be faster. In order to stop the containers, hit `Ctrl+C` in the active window.

{% hint style="info" %}
You can use the command `docker-compose up -d` instead to run MedCo in the background and thus not keeping the console captive. In that case use `docker-compose stop` to stop the containers.
{% endhint %}

## Keycloak Configuration

{% hint style="warning" %}
Only needed if you are deploying somewhere else than your local host. Otherwise the default configuration will work fine.
{% endhint %}

Follow the instructions for [configuring the MedCo OpenID Connect client in Keycloak](configuration/keycloak.md#medco-openid-connect-client) to be able to login in Glowing Bear.

## Test the deployment

In order to test that the local test deployment of MedCo is working, access Glowing Bear in your web browser at `http(s)://${MEDCO_NODE_HOST}` and use the default credentials specified in [Keycloak user management](configuration/keycloak.md#user-management). If you are new to Glowing Bear you can watch the [Glowing Bear user interface walkthrough](https://glowingbear.app/) video. You can also use the [CLI client](../cli.md) to perform tests.

By default MedCo loads a specific test data, refer to [Description of the default test data](../../developers/description-of-the-default-test-data.md) for expected results to queries. To load a dataset, follow the guide [Loading Data](../data-loading/).

