.. _lbl_loading_data:

Loading Data
============

..  toctree::
    :maxdepth: 3
    :includehidden:

    v0
    v1

The current version offers two different loading alternatives: (*v0*) loading of clinical and genomic data based on MAF datasets;
and (*v1*) loading of generic i2b2 data.
Currently these two loaders support each one dataset:

- *v0*: a genomic dataset (*tcga_cbio* publicly available in `cBioPortal <http://www.cbioportal.org/>`_)
- *v1*: the `i2b2 demodata <https://www.i2b2.org/software/repository.html?t=demo&p=15>`_.

Future releases of this software will allow for other arbitrary data sources, given that they follow a specific structure (e.g. BAM format).


Pre-Requisites
--------------

First get the repository containing the MedCo loader software, which already contains some test data for you to work with.
Not that you need *git-lfs* for those data to be retrieved with the repository.

.. code-block:: bash

    $ cd ~
    $ git clone -b v0.1.1 https://github.com/lca1/medco-loader.git

**Building Application**

To get the MedCo loader application, pull it with Docker:

.. code-block:: bash

    docker pull medco/medco-loader:v0.1.1

