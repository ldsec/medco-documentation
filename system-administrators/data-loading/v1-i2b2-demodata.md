# v1 \(I2B2 Demodata\)

The _v1_ loader expects an already existing i2b2 database \(in _.csv_ format\) that will be converted in a way that is compliant with the MedCo data model. This involves encrypting and deterministically tagging some of the data.

List of input \(‘original’\) files:

* all i2b2metadata files \(e.g. i2b2.csv\)
* dummy\_to\_patient.csv
* patient\_dimension.csv
* visit\_dimension.csv
* concept\_dimension.csv
* modifier\_dimension.csv
* observation\_fact.csv
* table\_access.csv

## How to use

{% hint style="info" %}
Ensure you have [downloaded the data](./#pre-requisite-download-test-data) before proceeding to the loading.
{% endhint %}

The following examples show you how to load data into a running MedCo deployment. Adapt accordingly the commands your use-case.

### Examples

#### Loading the three nodes on the dev-local-3nodes profile

```bash
export MEDCO_SETUP_DIR=~/medco-deployment \
    MEDCO_DEPLOYMENT_PROFILE=dev-local-3nodes
cd "${MEDCO_SETUP_DIR}/compose-profiles/${MEDCO_DEPLOYMENT_PROFILE}"
docker-compose -f docker-compose.tools.yml run medco-loader-srv0 v1 \
    --sen /data/i2b2/sensitive.txt \
    --files /data/i2b2/files.toml
docker-compose -f docker-compose.tools.yml run medco-loader-srv1 v1 \
    --sen /data/i2b2/sensitive.txt \
    --files /data/i2b2/files.toml
docker-compose -f docker-compose.tools.yml run medco-loader-srv2 v1 \
    --sen /data/i2b2/sensitive.txt \
    --files /data/i2b2/files.toml
```

#### Loading one node on a network-test profile

```bash
export MEDCO_SETUP_DIR=~/medco-deployment \
    MEDCO_DEPLOYMENT_PROFILE=test-network-xxx-node0
cd "${MEDCO_SETUP_DIR}/compose-profiles/${MEDCO_DEPLOYMENT_PROFILE}"
docker-compose -f docker-compose.tools.yml run medco-loader v1 \
    --sen /data/i2b2/sensitive.txt \
    --files /data/i2b2/files.toml
```

### Explanation of the command's arguments

```text
NAME:
    medco-loader v1 - Convert existing i2b2 data model

USAGE:
    medco-loader v1 [command options] [arguments...]

OPTIONS:
    --group value, -g value               UnLynx group definition file
    --entryPointIdx value, --entry value  Index (relative to the group definition file) of the collective authority server to load the data
    --sensitive value, --sen value        File containing a list of sensitive concepts
    --dbHost value, --dbH value           Database hostname
    --dbPort value, --dbP value           Database port (default: 0)
    --dbName value, --dbN value           Database name
    --dbUser value, --dbU value           Database user
    --dbPassword value, --dbPw value      Database password
    --files value, -f value               Configuration toml with the path of the all the necessary i2b2 files
    --empty, -e                           Empty patient and visit dimension tables (y/n)
```

### Test that the loading was successful

To check that it is working you can query for:

`-> Diagnoses -> Neoplasm -> Benign neoplasm -> Benign neoplasm of breast`

You should obtain 2 matching subjects.

