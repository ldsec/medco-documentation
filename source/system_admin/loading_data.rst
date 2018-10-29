.. _lbl_loading_data:

Loading Data
------------

The current version offers two different loading alternatives: (v0) loading of genomic data; and (v1) loading of encrypted i2b2 data.

First get the repository containing the MedCo loader software, which already contains some test data for you to work with. 
Currently there are two different datasets: a genomic dataset (tcga_cbio publicly available in `cbio portal <http://www.cbioportal.org/>`_) and a protected version of the `i2b2 demodata <https://www.i2b2.org/software/repository.html?t=demo&p=15>`_.
Future releases of this software will allow for other arbitrary data sources, given that they follow a specific structure (e.g. BAM format).

.. code-block:: bash

    $ cd ~
    $ git clone https://github.com/lca1/medco-loader.git

**Building Application**

There are two different ways to build the medco-loader application. If Go and the necessary requirements (libraries) are installed in your machine:

.. code-block:: bash

    cd ~/medco-loader/app/
    go build -o medco-loader *.go

or simply run the following bash script,

.. code-block:: bash

    cd ~/medco-loader/app/
    bash compileLinux.sh

If do not possess the environment to build go applications you can use our docker container to get the executable.

.. code-block:: bash

    cd ~/medco-loader/docker/
    bash run.sh

v0 (Genomic Data)
+++++++++++++++++

v0 expects an ontology, as well as, mutation and clinical data. As the ontology data you must use ``data/genomic/tcga_cbio/clinical_data.csv`` and ``data/genomic/tcga_cbio/mutation_data.csv``. 
As clinical data you can keep using the same two files or a subset of the data (e.g. 8_clinical_data.csv). More information about how to generate sample datafiles can be found below. 
All the data is encrypted and 'deterministically tagged' and it is compliant with the MedCo data model.

**To run v0 (example).**

.. code-block:: bash

    ./medco-loader -debug 2 v0 \
    --group group.toml --entryPointIdx 0 \
    --ont_clinical ../data/genomic/tcga_cbio/8_clinical_data.csv \
    --sen ../data/genomic/sensitive.txt  \
    --ont_genomic ../data/genomic/tcga_cbio/8_mutation_data.csv  \
    --clinical ../data/genomic/tcga_cbio/8_clinical_data.csv \
    --genomic ../data/genomic/tcga_cbio/8_mutation_data.csv \
    --output ../data/genomic/ \
    --dbHost localhost --dbPort 5432 --dbName i2b2medcosrv0 \ 
    --dbUser i2b2 --dbPassword i2b2

Explanation of the arguments:

.. code-block:: bash

    NAME:
        medco-loader v0 - Load genomic data (e.g. tcga_bio dataset)

    USAGE:
        medco-loader v0 [command options] [arguments...]

    OPTIONS:
        --group value, -g value               UnLynx group definition file
        --entryPointIdx value, --entry value  Index (relative to the group definition file) of the collective authority server to load the data (default: 0)
        --sensitive value, --sen value        File containing a list of sensitive concepts
        --dbHost value, --dbH value           Database hostname
        --dbPort value, --dbP value           Database port (default: 0)
        --dbName value, --dbN value           Database name
        --dbUser value, --dbU value           Database user
        --dbPassword value, --dbPw value      Database password
        --ont_clinical value, --oc value      Clinical ontology to load (default: "../../data/genomic/tcga_cbio/clinical_data.csv")
        --ont_genomic value, --og value       Genomic ontology to load (default: "../../data/genomic/tcga_cbio/mutation_data.csv")
        --clinical value, --cl value          Clinical file to load (default: "../../data/genomic/tcga_cbio/clinical_data.csv")
        --genomic value, --gen value          Genomic file to load (default: "../../data/genomic/tcga_cbio/mutation_data.csv")
        --output value, -o value              Output path to the .csv files (default: "../data/genomic/")

For more help simply type

.. code-block:: bash

    ./medco-loader v0 -help

If you followed the 3-node deployment in a single host machine you can simply execute:

.. code-block:: bash

    cd ~/medco-loader/app/
    bash testGenomic.sh

**Data Manipulation**

Inside /data/scripts/ you can find a small python application to extract (or replicate) data out of the original tcga_cbio dataset. 
You can decide which patients do you want to consider for you 'new' dataset or simply randomly pick a sample.

v1 (I2B2 Demodata)
++++++++++++++++++

v1 expects an already existing i2b2 database (.csv style format) that will be converted in a way that is compliant with the MedCo data model. 
This involves encrypting and 'deterministically tagging' some of the data.

List of input ('original') files:

.. code-block:: bash

    -> all i2b2metadata files(e.g. i2b2.csv)            
    -> dummy_to_patient.csv*
    -> patient_dimension.csv
    -> visit_dimension.csv
    -> concept_dimension.csv
    -> modifier_dimension.csv
    -> observation_fact.csv*
    *obtained by running the dummy generation script

**Dummy Generation**

-----------------------------------------------------------------------------

**Important Notice**

The test data (``data/i2b2/original``) in the repository as been pre-masked so you do not need to actually run this dummy generation step.

-----------------------------------------------------------------------------

Before running the loader we need to generate random dummy entries to prevent frequency attacks. 
For that we have to generate a new observation_fact.csv from the original one and new set of patients (dummy_to_patient.csv). 
For more information on how this dummy generation is done please refer to /data/scripts/import-tool/report/report.pdf.

If you have Jupyter Notebook with python enabled simply run /data/scripts/import-tool/using_clustering.ipynb. 
If not, from the command line you can convert a notebook to python with this command:

.. code-block:: bash

    ipython nbconvert --to python <YourNotebook>.ipynb

You may have to install the python mistune package:

.. code-block:: bash

    sudo pip install mistune

**To run v1 (example).**

.. code-block:: bash

    ./medco-loader -debug 2 v1 \
    --group group.toml --entry 0 \
    --sen ../data/i2b2/sensitive.txt\ 
    --files ../data/i2b2/files.toml \
    --dbHost localhost  --dbPort 5432 --dbName i2b2medcosrv0 \
    --dbUser i2b2 --dbPassword i2b2

.. code-block:: bash

    NAME:
        medco-loader v1 - Convert existing i2b2 data model

    USAGE:
        medco-loader v1 [command options] [arguments...]

    OPTIONS:
        --group value, -g value               UnLynx group definition file
        --entryPointIdx value, --entry value  Index (relative to the group definition file) of the collective authority server to load the data (default: 0)
        --sensitive value, --sen value        File containing a list of sensitive concepts
        --dbHost value, --dbH value           Database hostname
        --dbPort value, --dbP value           Database port (default: 0)
        --dbName value, --dbN value           Database name
        --dbUser value, --dbU value           Database user
        --dbPassword value, --dbPw value      Database password
        --files value, -f value               Configuration toml with the path of the all the necessary i2b2 files (default: "files.toml")
        --empty, -e                           Empty patient and visit dimension tables (y/n)

For more help simply type

.. code-block:: bash

    ./medco-loader v1 -help

If you followed the 3-node deployment in a single host machine you can simply execute:

.. code-block:: bash

    cd ~/medco-loader/app/
    bash testI2B2.sh

