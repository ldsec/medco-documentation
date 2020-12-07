# Command-Line Interface \(CLI\)

MedCo provides a client command-line interface \(CLI\) to interact with the _medco-connector_ APIs.

## Prerequisites

To use the CLI, you must first follow one of the [deployment guides](deployment/). However, the version of the CLI documented here is the one shipped with the [Local Development Deployment](../developers/local-development-deployment.md).

## How to use

To show the CLI manual, run:

```text
export MEDCO_SETUP_DIR=~/medco
cd ${MEDCO_SETUP_DIR}/deployments/dev-local-3nodes/
docker-compose -f docker-compose.tools.yml run medco-cli-client --user [USERNAME] --password [PASSWORD] --help

NAME:
   medco-cli-client - Command-line query tool for MedCo.

USAGE:
   medco-cli-client [global options] command [command options] [arguments...]

VERSION:
   dev

COMMANDS:
   concept-children, con-c     Get the concept children (both concepts and modifiers)
   modifier-children, mod-c    Get the modifier children
   concept-info, con-i         Get the concept info
   modifier-info, mod-i        Get the modifier info
   query, q                    Query the MedCo network
   ga-get-values, ga-val       Get the values of the genomic annotations of type *annotation* whose values contain *value*
   ga-get-variant, ga-var      Get the variant ID of the genomic annotation of type *annotation* and value *value*
   survival-analysis, srva     Run a survival analysis
   get-saved-cohorts, getsc    get cohorts
   add-saved-cohorts, addsc    Create a new cohort.
   update-saved-cohorts, upsc  Updates an existing cohort.
   remove-saved-cohorts, rmsc  Remove a cohort.
   help, h                     Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --user value, -u value        OIDC user login
   --password value, -p value    OIDC password login
   --token value, -t value       OIDC token
   --disableTLSCheck             Disable check of TLS certificates
   --outputFile value, -o value  Output file for the result. Printed to stdout if omitted.
   --help, -h                    show help
   --version, -v                 print the version
```

{% hint style="info" %}
For a start, you can use the credentials of the default user: `username:test password:test`
{% endhint %}

### concept-children

You can use this command to browse the MedCo ontology by getting the children of a concept, both concepts and modifiers.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test concept-children --help
NAME:
   medco-cli-client concept-children - Get the concept children (both concepts and modifiers)

USAGE:
   medco-cli-client concept-children conceptPath
```

For example:

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test concept-children /E2ETEST/e2etest/ 
PATH	TYPE
/E2ETEST/e2etest/1/	concept
/E2ETEST/e2etest/2/	concept
/E2ETEST/e2etest/3/	concept
/E2ETEST/modifiers/	modifier_folder
```

### modifier-children

You can use this command to browse the MedCo ontology by getting the children of a modifier.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test modifier-children --help
NAME:
   medco-cli-client modifier-children - Get the modifier children

USAGE:
   medco-cli-client modifier-children modifierPath appliedPath appliedConcept
```

For example:

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test modifier-children /E2ETEST/modifiers/ /e2etest/% /E2ETEST/e2etest/1/
PATH	TYPE
/E2ETEST/modifiers/1/	modifier
```

### concept-info

You can use this command to get information about a MedCo concept, including the associated metadata.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test concept-info --help
NAME:
   medco-cli-client concept-info - Get the concept info

USAGE:
   medco-cli-client concept-info conceptPath
```

For example:

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test concept-info /E2ETEST/e2etest/1/ 
  <ExploreSearchResultElement>
      <Code>ENC_ID:1</Code>
      <DisplayName>E2E Concept 1</DisplayName>
      <Leaf>true</Leaf>
      <MedcoEncryption>
          <Encrypted>true</Encrypted>
          <ID>1</ID>
      </MedcoEncryption>
      <Metadata>
          <ValueMetadata>
              <ChildrenEncryptIDs></ChildrenEncryptIDs>
              <CreationDateTime></CreationDateTime>
              <DataType></DataType>
              <EncryptedType></EncryptedType>
              <EnumValues></EnumValues>
              <Flagstouse></Flagstouse>
              <NodeEncryptID></NodeEncryptID>
              <Oktousevalues></Oktousevalues>
              <TestID></TestID>
              <TestName></TestName>
              <Version></Version>
          </ValueMetadata>
      </Metadata>
      <Name>E2E Concept 1</Name>
      <Path>/E2ETEST/e2etest/1/</Path>
      <Type>concept</Type>
  </ExploreSearchResultElement>
```

### modifier-info

You can use this command to get information about a MedCo modifier, including the associated metadata.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test modifier-info --help
NAME:
   medco-cli-client modifier-info - Get the modifier info

USAGE:
   medco-cli-client modifier-info modifierPath appliedPath
```

For example:

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test modifier-info /E2ETEST/modifiers/1/ /e2etest/1/
  <ExploreSearchResultElement>
      <Code>ENC_ID:5</Code>
      <DisplayName>E2E Modifier 1</DisplayName>
      <Leaf>true</Leaf>
      <MedcoEncryption>
          <Encrypted>true</Encrypted>
          <ID>5</ID>
      </MedcoEncryption>
      <Metadata>
          <ValueMetadata>
              <ChildrenEncryptIDs></ChildrenEncryptIDs>
              <CreationDateTime></CreationDateTime>
              <DataType></DataType>
              <EncryptedType></EncryptedType>
              <EnumValues></EnumValues>
              <Flagstouse></Flagstouse>
              <NodeEncryptID></NodeEncryptID>
              <Oktousevalues></Oktousevalues>
              <TestID></TestID>
              <TestName></TestName>
              <Version></Version>
          </ValueMetadata>
      </Metadata>
      <Name>E2E Modifier 1</Name>
      <Path>/E2ETEST/modifiers/1/</Path>
      <Type>modifier</Type>
  </ExploreSearchResultElement>
```

### query

You can use this command to query the MedCo network.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test query --help

NAME:
   medco-cli-client query - Query the MedCo network

USAGE:
   medco-cli-client query [command options] [-t timing] query_string

OPTIONS:
   --timing value, -t value  Query timing: any|samevisit|sameinstancenum (default: "any")
```

This is the syntax of an example query using the pre-loaded [default test data](../developers/description-of-the-default-test-data.md).

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test query patient_list enc::1 AND enc::2 OR enc::3
```

You will get something like that:

```text
node_name,count,patient_list,DDTRequestTime,KSRequestTime,KSTimeCommunication,KSTimeExec,TaggingTimeCommunication,TaggingTimeExec,medco-connector-DDT,medco-connector-i2b2-PDO,medco-connector-i2b2-PSM,medco-connector-local-agg,medco-connector-local-patient-list-masking,medco-connector-overall,medco-connector-unlynx-key-switch-count,medco-connector-unlynx-key-switch-patient-list
0,1,[2],4236,311,307,0,1657,10,4266,3972,25472,1,153,34834,469,491
1,1,[2],584,89,75,0,474,78,677,4717,61325,16,3,66991,140,104
2,1,[2],669,55,45,0,576,49,709,3134,63371,0,8,67358,68,63
```

Query terms can be composed using the logical operators NOT, AND and OR.

{% hint style="info" %}
Note that, in the queries, the OR operator has the highest priority, so`1 AND NOT 2 OR 3 AND 2` is factorised as `(1) AND (NOT (2 OR 3)) AND (2)`

`To each group of OR-ed terms you can also add a timing option ("any", "samevisit", "sameinstancenum") that will ovveride the globally set timing option. For example:` 

`1 AND NOT 2 OR 3 samevisit AND 2`
{% endhint %}



Each query term is composed is composed of two mandatory fields, the type field and the content field, and an optional field, the constraint field, all separated by `::`. 

                                                    `type::content[::constraint]`

Possible values of the type field are: `enc`, `clr`, `file`.

1. When the type field is equal to `enc`, the content field contains the concept ID. The constraint field is not present this case.
2. When the type field is equal to `clr,` the content field contains the concept field \(containing the concept path\) and, possibly, the modifier field, which in turn contains the modifier key and applied path fields, all separated by `:`. The optional constraint field can be present, containing the operator and value fields separated by `:`. The constraint field applies either to the concept or, if the modifier field is present, to the modifier. The possible operators are: EQ \(equals\), NE \(not equal\), GT \(greater than\), LT \(less than\), GE \(greater than or equal\), LE \(less than or equal\), BETWEEN \(between, in this case the value field is in the format "x and y"\).
3. When the type field is equal to `file`, the content field contains the path of the file containing the query terms, one for each row. The query terms contained in the same file are OR-ed together. Besides `enc`, `clr,` and `file` query terms, a file can also contain genomic query terms, each of which is composed by 4 comma separated values. 

### ga-get-values

You can use this command to get the values of the genomic annotations that MedCo nodes make available for queries.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test ga-get-values --help

NAME:
   medco-cli-client ga-get-values - Get the values of the genomic annotations of type *annotation* whose values contain *value*

USAGE:
   medco-cli-client ga-get-values [command options] [-l limit] annotation value

OPTIONS:
   --limit value, -l value  Maximum number of returned values (default: 0)
```

To do some tests, you may want to [load some data first](data-loading/v0-genomic-data.md).

Then, for example, if you want to know which genomic annotations of type "protein\_change" containing the string "g32" are available, you can run:

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test ga-get-values protein_change g32
```

You will get:

```text
G325R
G32E
```

{% hint style="info" %}
The matching is case-insensitive and it is not possible to use wildcards. At the moment, with the loader v0, only three types of genomic annotations are available: variant\_name, protein\_change and hugo\_gene\_symbol.
{% endhint %}

### ga-get-variant

You can use this command to get the variant ID of a certain genomic annotation.

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test ga-get-variant --help

NAME:
   medco-cli-client ga-get-variant - Get the variant ID of the genomic annotation of type *annotation* and value *value*

USAGE:
   medco-cli-client ga-get-variant [command options] [-z zygosity] [-e] annotation value

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
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test ga-get-variant -z "heterozygous|homozygous" hugo_gene_symbol HTR5A
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

