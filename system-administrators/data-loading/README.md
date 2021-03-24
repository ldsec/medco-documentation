# Data Loading

There are two ways of loading data into MedCo. The first, using the provided loader, allows to encrypt and load the encrypted data into the MedCo database. The second loads directly pre-generated data into the database without encrypting data.

## Load pre-generated data

Pre-generated cleartext synthetic data following the SPO \(Swiss Personalized Oncology\) ontology is available, [follow those instructions to load them.](synthetic-spo-data.md)

## Encrypt and load data with the loader

The current version of the loader offers two different loading alternatives: \(_v0_\) loading of clinical and genomic data based on MAF datasets; and \(_v1_\) loading of generic i2b2 data. Currently these two loaders support each one dataset:

* _v0_: a genomic dataset \(_tcga\_cbio_ publicly available in [cBioPortal](http://www.cbioportal.org/)\)
* _v1_: the [i2b2 demodata](https://www.i2b2.org/software/repository.html?t=demo&p=15).

Future releases of this software will allow for other arbitrary data sources, given that they follow a specific structure \(e.g. BAM format\).

### Pre-Requisite: Download test data

Execute the download script to download the test datasets.

```bash
cd ${MEDCO_SETUP_DIR}/test/data
bash download.sh i2b2
bash download.sh genomic_orig
bash download.sh genomic_fake
bash download.sh genomic_small
```

### Dummy Generation

The provided example data set files come with dummy data pre-generated. Those data are random dummy entries whose purpose is to prevent frequency attacks. In a future release, the generation will be done dynamically by the loader.



