.. _lbl_loading_data:

Loading Data
============

..  toctree::
    :maxdepth: 3
    :includehidden:

    v0
    v1

The current version offers two different loading alternatives: (*v0*) loading of clinical and genomic data based on MAF
datasets; and (*v1*) loading of generic i2b2 data. Currently these two loaders support each one dataset:

- *v0*: a genomic dataset (*tcga_cbio* publicly available in `cBioPortal <http://www.cbioportal.org/>`_)
- *v1*: the `i2b2 demodata <https://www.i2b2.org/software/repository.html?t=demo&p=15>`_.

Future releases of this software will allow for other arbitrary data sources, given that they follow a specific
structure (e.g. BAM format).


Pre-Requisites
--------------

**Download test data**

From the *medco-deployment* folder, execute the `resources/data/download.sh` script to download the test datasets.

.. code-block:: bash

    $ cd ~/medco-deployment/resources/data
    $ bash download.sh
