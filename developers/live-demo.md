# Live Demo

The live demo of MedCo is available at [https://medco-demo.epfl.ch](https://medco-demo.epfl.ch). The profile `test-local-3nodes` with a custom configuration is used.

## Information about the machine and deployment

* Any new added administrator should belong to the groups `sudo`, `docker` and `lds`, and have its SSH key set up.
* The files of the deployment \(`/opt/medco`\) have the group `lds` set.
* Updates of the system should be regularly done.
* After a reboot, the MedCo deployment will not persist and must be started manually.
* While the renewal of the certificate may be done automatically with Let's Encrypt, it is not automatically set up in the MedCo deployment, thus every 2-3 months this should be updated.
* The Keycloak of the deployment is set up to demonstrate the connection with SwitchAAI. This includes having some keys configured in Keycloak, so be careful to not wipe the database in order to not loose those keys, otherwise the configuration will have to be redone.

## Update demo version

Connect with SSH to the machine \(you should have your SSH key set up there\). 

### Get the latest version

Ensure the configuration specific to the MedCo stays \(see next section\).

```bash
cd /opt/medco/deployments/test-local-3nodes
make down
git pull
```

### Configuration update

Update the configuration according to the following examples. For the passwords, use the same as defined in the previous deployments.

{% code title="/opt/medco/deployments/test-local-3nodes/.env" %}
```bash
MEDCO_NODE_HOST=medco-demo.epfl.ch
MEDCO_NODE_HTTP_SCHEME=https
POSTGRES_PASSWORD=xxx
PGADMIN_PASSWORD=xxx
KEYCLOAK_PASSWORD=xxx
I2B2_WILDFLY_PASSWORD=xxx
I2B2_SERVICE_PASSWORD=xxx
I2B2_USER_PASSWORD=xxx
```
{% endcode %}

{% code title="/opt/medco/deployments/test-local-3nodes/docker-compose.yml" %}
```yaml
  glowing-bear-medco:
    environment:
      - "GB_FOOTER_TEXT=Disclaimer: This demo complies with the EPFL regulations and guidelines regarding the storage and use of personal data: https://www.epfl.ch/about/overview/overview/regulations-and-guidelines/"
```
{% endcode %}

### Start deployment

```bash
cd /opt/medco/deployments/test-local-3nodes
make up
```

### Load synthetic demo data

Get them from the Google Drive folder and execute the script.

```bash
cd /opt/medco
./test/data/download.sh spo_synthetic

./scripts/load-spo-i2b2-data.sh localhost i2b2medcosrv0 medcoconnectorsrv0
./scripts/load-spo-i2b2-data.sh localhost i2b2medcosrv1 medcoconnectorsrv1
./scripts/load-spo-i2b2-data.sh localhost i2b2medcosrv2 medcoconnectorsrv2
```

## Update certificate

The certificate is provided by Let's Encrypt and valid for a period of 3 months, it thus needs regular renewing. First ensure that the configuration located in `/etc/letsencrypt/renewal/medco-demo.epfl.ch.conf` is correct.

Then with sudo rights renew the certificate:

```bash
certbot renew
cp /etc/letsencrypt/live/medco-demo.epfl.ch/fullchain.pem \
    /opt/medco/deployments/test-local-3nodes/configuration/certificate.crt
cp /etc/letsencrypt/live/medco-demo.epfl.ch/privkey.pem \
    /opt/medco/deployments/test-local-3nodes/configuration/certificate.key
```

And finally restart the stack:

```bash
cd /opt/medco/deployments/test-local-3nodes
make stop
make up
```

