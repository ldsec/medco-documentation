# Live Demo

The live demo of MedCo is available at [https://medco-demo.epfl.ch](https://medco-demo.epfl.ch). The profile `test-local-3nodes` with a custom configuration is used.

## Update demo version

Connect with SSH to the machine, with the `lca1` account. Ask Mickaël or Joao to set up your SSH public key there. 

### Get the latest version

Adapt the exported variables to the current versions.

```bash
export OLD_VER=0.2.1 NEW_VER=0.3.0

cd /home/lca1/medco-deployment/compose-profiles/test-local-3nodes
docker-compose down

cd /home/lca1
mv medco-deployment medco-deployment-${OLD_VER}
wget https://github.com/ldsec/medco-deployment/archive/v${NEW_VER}.tar.gz
tar xvzf v${NEW_VER}.tar.gz
mv medco-deployment-${NEW_VER} medco-deployment
```

### Configuration update

Update the configuration according to the following examples. For the passwords, use the same as defined in the previous deployments.

{% code title="/home/lca1/medco-deployment/compose-profiles/test-local-3nodes/.env" %}
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

{% code title="/home/lca1/medco-deployment/compose-profiles/test-local-3nodes/docker-compose.yml" %}
```yaml
  glowing-bear-medco:
    environment:
      - "GB_FOOTER_TEXT=Disclaimer: This demo complies with the EPFL regulations and guidelines regarding the storage and use of personal data: https://www.epfl.ch/about/overview/overview/regulations-and-guidelines/"
```
{% endcode %}

### Copy the previously used certificate

```bash
cp /home/lca1/medco-deployment-${OLD_VER}/configuration-profiles/test-local-3nodes/certificate.* \
    /home/lca1/medco-deployment/configuration-profiles/test-local-3nodes/
```

### Start deployment

```bash
cd medco-deployment/compose-profiles/test-local-3nodes
docker-compose up -d
```

### Load v0 dataset \(synthetic\)

```bash
cd /home/lca1/medco-deployment/resources/data
bash download.sh

cd /home/lca1/medco-deployment/compose-profiles/test-local-3nodes
docker-compose -f docker-compose.tools.yml run medco-loader-srv0 v0 \
    --ont_clinical /data/genomic/tcga_cbio/clinical_data_fake.csv \
    --sen /data/genomic/sensitive.txt \
    --ont_genomic /data/genomic/tcga_cbio/mutation_data_fake.csv \
    --clinical /data/genomic/tcga_cbio/clinical_data_fake.csv \
    --genomic /data/genomic/tcga_cbio/mutation_data_fake.csv \
    --output /data/
docker-compose -f docker-compose.tools.yml run medco-loader-srv1 v0 \
    --ont_clinical /data/genomic/tcga_cbio/clinical_data_fake.csv \
    --sen /data/genomic/sensitive.txt \
    --ont_genomic /data/genomic/tcga_cbio/mutation_data_fake.csv \
    --clinical /data/genomic/tcga_cbio/clinical_data_fake.csv \
    --genomic /data/genomic/tcga_cbio/mutation_data_fake.csv \
    --output /data/
docker-compose -f docker-compose.tools.yml run medco-loader-srv2 v0 \
    --ont_clinical /data/genomic/tcga_cbio/clinical_data_fake.csv \
    --sen /data/genomic/sensitive.txt \
    --ont_genomic /data/genomic/tcga_cbio/mutation_data_fake.csv \
    --clinical /data/genomic/tcga_cbio/clinical_data_fake.csv \
    --genomic /data/genomic/tcga_cbio/mutation_data_fake.csv \
    --output /data/
```

## Update certificate

The certificate is provided by Let's Encrypt and valid for a period of 3 months, it thus needs regular renewing. First ensure that the configuration located in `/etc/letsencrypt/renewal/medco-demo.epfl.ch.conf` is correct.

Then as the user `root`, renew the certificate:

```bash
certbot renew
cp /etc/letsencrypt/live/medco-demo.epfl.ch/fullchain.pem \
    /home/lca1/medco-deployment/configuration-profiles/test-local-3nodes/certificate.crt
cp /etc/letsencrypt/live/medco-demo.epfl.ch/privkey.pem \
    /home/lca1/medco-deployment/configuration-profiles/test-local-3nodes/certificate.key 
```

Finally as the user `lca1` restart nginx:

```bash
cd /home/lca1/medco-deployment/compose-profiles/test-local-3nodes
docker-compose stop nginx
docker-compose up -d nginx
```

