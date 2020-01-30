# Loading Data

* [v0 \(Genomic Data\)](v0-genomic-data.md)
  * [Example](v0-genomic-data.md#example)
  * [Data Manipulation](v0-genomic-data.md#data-manipulation)
* [v1 \(I2B2 Demodata\)](v1-i2b2-demodata.md)
  * [Dummy Generation](v1-i2b2-demodata.md#dummy-generation)
  * [Example](v1-i2b2-demodata.md#example)

The current version offers two different loading alternatives: \(_v0_\) loading of clinical and genomic data based on MAF datasets; and \(_v1_\) loading of generic i2b2 data. Currently these two loaders support each one dataset:

* _v0_: a genomic dataset \(_tcga\_cbio_ publicly available in [cBioPortal](http://www.cbioportal.org/)\)
* _v1_: the [i2b2 demodata](https://www.i2b2.org/software/repository.html?t=demo&p=15).

Future releases of this software will allow for other arbitrary data sources, given that they follow a specific structure \(e.g. BAM format\).

### Pre-Requisites

**Download test data**

From the _medco-deployment_ folder, execute the resources/data/download.sh script to download the test datasets.

```text
$ cd ~/medco-deployment/resources/data
$ bash download.sh
```

