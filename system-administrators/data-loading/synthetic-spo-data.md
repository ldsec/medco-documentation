---
description: >-
  This page will guide you through loading example synthetic data that follows
  the SPO (Swiss Personalized Oncology) ontology.
---

# Synthetic SPO Data

## Pre-Requisite: Download test data

Execute the download script to download the test datasets.

```bash
cd ${MEDCO_SETUP_DIR}/test/data
bash download.sh spo_synthetic
```

## Load the data into MedCo

A script is available to load in a simple way the data. Example of how to use it with a `test-local-3nodes` deployment running on your localhost, adapt it to your own use-case:

```bash
cd ${MEDCO_SETUP_DIR}/scripts
for NODE_NB in 0 1 2; do bash load-spo-i2b2-data.sh \
  ../test/data/spo-synthetic/node_${NODE_NB} \
  localhost i2b2medcosrv${NODE_NB} \
  medcoconnectorsrv${NODE_NB}; \
done
```

