# Command-Line Interface \(CLI\)

MedCo provides a client command-line interface \(CLI\) to interact with the _medco-connector_ APIs.

## Prerequisites

To use the CLI, you must first follow one of the [deployment guides](deployment/). However, the version of the CLI documented here is the one shipped with the [Local Development Deployment](../developers/local-development-deployment.md).

## How to use

To show the CLI manual, run:

```text
export MEDCO_SETUP_DIR=~/medco-deployment
cd ${MEDCO_SETUP_DIR}/compose-profiles/dev-local-3nodes/
docker-compose -f docker-compose.tools.yml run medco-cli-client --user [USERNAME] --password [PASSWORD] --help

NAME:
   medco-cli-client - Command-line query tool for MedCo.

USAGE:
   medco-cli-client [global options] command [command options] [arguments...]

VERSION:
   1.0.0

COMMANDS:
   query, q                                Query the MedCo network
   genomic-annotations-get-values, gval    Get genomic annotations values
   genomic-annotations-get-variants, gvar  Get genomic annotations variants
   survival-analysis, srva                 Run a survival analysis
   help, h                                 Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --user value, -u value      OIDC user login
   --password value, -p value  OIDC password login
   --token value, -t value     OIDC token
   --disableTLSCheck           Disable check of TLS certificates
   --help, -h                  show help
   --version, -v               print the version
```

{% hint style="info" %}
For a start, you can use the credentials of the default user: `username:test password:test`
{% endhint %}

### query

You can use this command to query the MedCo network.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test query --help

NAME:
   medco-cli-client query - Query the MedCo network

USAGE:
   medco-cli-client query [command options] [patient_list|count_per_site|count_per_site_obfuscated|count_per_site_shuffled|count_per_site_shuffled_obfuscated|count_global|count_global_obfuscated] [query string]

OPTIONS:
   --resultFile value, -r value  Output file for the result CSV. Printed to stdout if omitted.
```

This is the syntax of an example query using the pre-loaded [default test data](../developers/description-of-the-default-test-data.md).

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test query patient_list 1 AND 2 OR 3
```

You will get something like that:

```text
node_name,count,patient_list,DDTRequestTime,KSRequestTime,KSTimeCommunication,KSTimeExec,TaggingTimeCommunication,TaggingTimeExec,medco-connector-DDT,medco-connector-i2b2-PDO,medco-connector-i2b2-PSM,medco-connector-local-agg,medco-connector-local-patient-list-masking,medco-connector-overall,medco-connector-unlynx-key-switch-count,medco-connector-unlynx-key-switch-patient-list
0,8,[1 2 3 4 5 6 7 8],268,162,154,0,218,23,275,2561,16507,0,32,19619,50,179
1,0,[],212,61,43,0,179,12,232,2078,17993,0,1,20433,38,87
2,0,[],196,38,30,0,172,7,216,1574,18889,1,2,20779,30,53
```

{% hint style="info" %}
Not that, in the queries, the OR operator has the highest priority, so `1 AND 2 OR 3 AND 2` is factorised as `(1) AND (2 OR 3) AND (2)`.
{% endhint %}

### genomic-annotations-get-values

You can use this command to get the values of the genomic annotations that MedCo nodes make available for queries.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test genomic-annotations-get-values --help

NAME:
   medco-cli-client genomic-annotations-get-values - Get genomic annotations values
USAGE:
   medco-cli-client genomic-annotations-get-values [command options] [-l limit] [annotation] [value]
OPTIONS:
   --limit value, -l value  Maximum number of returned values (default: 0)
```

To do some tests, you may want to [load some data first](data-loading/v0-genomic-data.md).

Then, for example, if you want to know which genomic annotations of type "protein\_change" containing the string "g32" are available, you can run:

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test genomic-annotations-get-values protein_change g32
```

You will get:

```text
G325R
G32E
```

{% hint style="info" %}
The matching is case-insensitive and it is not possible to use wildcards. At the moment, with the loader v0, only three types of genomic annotations are available: variant\_name, protein\_change and hugo\_gene\_symbol.
{% endhint %}

### genomic-annotations-get-variants

You can use this command to get the variant ID of a certain genomic annotation.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test genomic-annotations-get-variants --help

NAME:
   medco-cli-client genomic-annotations-get-variants - Get genomic annotations variants

USAGE:
   medco-cli-client genomic-annotations-get-variants [command options] [-z zygosity] [-e] [annotation] [value]

DESCRIPTION:
   zygosity can be either heterozygous, homozygous, unknown or a combination of the three separated by |
If omitted, the command will execute as if zygosity was equal to "heterozygous|homozygous|unknown|"

OPTIONS:
   --zygosity value, -z value  Variant zygosysty
   --encrypted, -e             Return encrypted variant id
```

To do some tests, you may want to [load some data first](data-loading/v0-genomic-data.md).

Then, for example, if you want to know the variant ID of the genomic annotation "HTR5A" of type "hugo\_gene\_symbol" with zygosity "heterozygous" or "homozygous", you can run:

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test genomic-annotations-get-variants -z "heterozygous|homozygous" hugo_gene_symbol HTR5A
```

You will get:

```text
-7039476204566471680
-7039476580443220992
```

{% hint style="info" %}
The matching is case-insensitive and it is not possible to use wildcards. If you request the ID of an annotation which is not available \(e.g, in the previous, example, "HTR5"\) you will get an error message. At the moment, with the loader v0, only three types of genomic annotations are available: variant\_name, protein\_change and hugo\_gene\_symbol.
{% endhint %}

### survival-analysis

You can run this command to get information useful to run survival analysis. The relative time points are computed as the difference between absolute dates of start concept and end concept.

```text
NAME:
   medco-cli-client survival-analysis - Run a survival analysis

USAGE:
   medco-cli-client survival-analysis [command options] -l limit [-g granularity] [-c cohortID] -s startConcept [-x startModifier] -e endConcept [-y endModifier]

DESCRIPTION:
   Returns the points of the survival curve

OPTIONS:
   --limit value, -l value          Max limit of survival analysis. (default: 0)
   --granularity value, -g value    Time resolution, one of [day, week, month, year] (default: "day")
   --cohortID value, -c value       Cohort identifier (default: -1)
   --startConcept value, -s value   Survival start concept
   --startModifier value, -x value  Survival start modifier (default: "@")
   --endConcept value, -e value     Survival end concept
   --endModifier value, -y value    Survival end modifier (default: "@")
```

Start and concept are determined by the name of the access table concatenated to the full path of the concept.

The default cohort identifier -1 corresponds to test data loaded for end-to-end testing. All future cohort identifiers will be positive integers. Cohorts can be created after a successful MedCo Explore query.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test srva  srva -l 2000 -g week -c 1  -s /SPHN/SPHNv2020.1/FophDiagnosis/ -e /SPHN/SPHNv2020.1/DeathStatus/ -y 126:1
```

{% hint style="info" %}
The matching is case-insensitive and it is not possible to use wildcards. If you request the ID of an annotation which is not available \(e.g, in the previous, example, "HTR5"\) you will get an error message. At the moment only three types of genomic annotations are available: variant\_name, protein\_change and hugo\_gene\_symbol.
{% endhint %}

