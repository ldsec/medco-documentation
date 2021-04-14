# v0 \(Genomic Data\)

The _v0_ loader expects an ontology, with mutation and clinical data in the MAF format. As the ontology data you must use `${MEDCO_SETUP_DIR}/test/data/genomic/tcga_cbio/clinical_data.csv` and `${MEDCO_SETUP_DIR}/test/data/genomic/tcga_cbio/mutation_data.csv`. For clinical data you can keep using the same two files or a subset of the data \(e.g. `8_clinical_data.csv`\). More information about how to generate sample data files can be found below. After the following script is executed all the data is encrypted and deterministically tagged in compliance with the MedCo data model.

## How to use

{% hint style="info" %}
Ensure you have [downloaded the data](./#pre-requisite-download-test-data) before proceeding to the loading.
{% endhint %}

The following examples show you how to load data into a running MedCo deployment. Adapt accordingly the commands your use-case.

### Examples

#### Loading the three nodes on the dev-local-3nodes profile

```bash
export MEDCO_SETUP_DIR=~/medco \
    MEDCO_DEPLOYMENT_PROFILE=dev-local-3nodes
cd "${MEDCO_SETUP_DIR}/deployments/${MEDCO_DEPLOYMENT_PROFILE}"
docker-compose -f docker-compose.tools.yml run medco-loader-srv0 v0 \
    --ont_clinical /data/genomic/tcga_cbio/8_clinical_data.csv \
    --sen /data/genomic/sensitive.txt \
    --ont_genomic /data/genomic/tcga_cbio/8_mutation_data.csv \
    --clinical /data/genomic/tcga_cbio/8_clinical_data.csv \
    --genomic /data/genomic/tcga_cbio/8_mutation_data.csv \
    --output /data/
docker-compose -f docker-compose.tools.yml run medco-loader-srv1 v0 \
    --ont_clinical /data/genomic/tcga_cbio/8_clinical_data.csv \
    --sen /data/genomic/sensitive.txt \
    --ont_genomic /data/genomic/tcga_cbio/8_mutation_data.csv \
    --clinical /data/genomic/tcga_cbio/8_clinical_data.csv \
    --genomic /data/genomic/tcga_cbio/8_mutation_data.csv \
    --output /data/
docker-compose -f docker-compose.tools.yml run medco-loader-srv2 v0 \
    --ont_clinical /data/genomic/tcga_cbio/8_clinical_data.csv \
    --sen /data/genomic/sensitive.txt \
    --ont_genomic /data/genomic/tcga_cbio/8_mutation_data.csv \
    --clinical /data/genomic/tcga_cbio/8_clinical_data.csv \
    --genomic /data/genomic/tcga_cbio/8_mutation_data.csv \
    --output /data/
```

#### Loading one node on a network-test profile

```bash
export MEDCO_SETUP_DIR=~/medco \
    MEDCO_DEPLOYMENT_PROFILE=test-network-xxx-node0
cd "${MEDCO_SETUP_DIR}/deployments/${MEDCO_DEPLOYMENT_PROFILE}"
docker-compose -f docker-compose.tools.yml run medco-loader v0 \
    --ont_clinical /data/genomic/tcga_cbio/8_clinical_data.csv \
    --sen /data/genomic/sensitive.txt \
    --ont_genomic /data/genomic/tcga_cbio/8_mutation_data.csv \
    --clinical /data/genomic/tcga_cbio/8_clinical_data.csv \
    --genomic /data/genomic/tcga_cbio/8_mutation_data.csv \
    --output /data/
```

### Explanation of the command's arguments

```text
NAME:
    medco-loader v0 - Load genomic data (e.g. tcga_bio dataset)

USAGE:
    medco-loader v0 [command options] [arguments...]

OPTIONS:
    --group value, -g value               UnLynx group definition file
    --entryPointIdx value, --entry value  Index (relative to the group definition file) of the collective authority server to load the data
    --sensitive value, --sen value        File containing a list of sensitive concepts
    --dbHost value, --dbH value           Database hostname
    --dbPort value, --dbP value           Database port (default: 0)
    --dbName value, --dbN value           Database name
    --dbUser value, --dbU value           Database user
    --dbPassword value, --dbPw value      Database password
    --ont_clinical value, --oc value      Clinical ontology to load
    --ont_genomic value, --og value       Genomic ontology to load
    --clinical value, --cl value          Clinical file to load
    --genomic value, --gen value          Genomic file to load
    --output value, -o value              Output path to the .csv files
```

### Test that the loading was successful

To check that it is working you can query for:

`-> MedCo Gemomic Ontology -> Gene Name -> BRPF3`

For the small dataset `8_xxxx` you should obtain 3 matching subjects \(one at each site\).

