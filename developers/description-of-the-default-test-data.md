# Description of the default test data

## MedCo Explore

The default data loaded in MedCo is a small artificially generated dataset, appropriate to test a fresh deployment. The same data is replicated on all the nodes. Note that as of now it is encrypted using the test keys, i.e. the ones used for deployment profiles `dev-local-3nodes` and `test-local-3nodes`.

It contains 4 patients: 1 \(real\), 2 \(real\), 3 \(real\), 4 \(dummy\).

And 3 concepts: 1, 2, and 3.

The observation fact contains the following entries:

* patient 1, concept 1
* patient 2, concept 1
* patient 2, concept 2
* patient 3, concept 2
* patient 3, concept 3
* patient 4, concept 1
* patient 4, concept 2
* patient 4, concept 3

Example queries and expected results \(per node\):

* 1 AND 2: 1 \(patient 2\)
* 2 AND 3: 1 \(patient 3\)
* 1 AND 2 AND 3: 0
* \(1 OR 2\): 3 \(patients 1, 2 and 3\)
* \(1 OR 3\) AND 2: 1 \(patients 2 and 3\) 

## MedCo Analysis - survival analysis

Default data for survival analysis consist on 228 fake patients. Each patient has observations relative to:

* Death status \(/SPHNv2020.1/DeathStatus/ and /DeathStatus-status/death in metadata\)
* Gender \(/I2B2/Demographics/Gender/Female/ and /I2B2/Demographics/Gender/Female/ in metadata\)
* A diagnosis \(/SPHNv2020.1/FophDiagnosis/  in metadata\)

All patients have the same diagnosis. It is used as the start event for computing relative times.

Death status have two possible values: death or unknown \(respectively 126:0 and 126:1 in modifier\_cd column of observation\_fact\). 165 patients are deceased, the remaining 63 have the unknown status. Death status is used as the end event for relative times. As unknown-status death observation is the latest one for those whose death is not recorded, this observation is also useful for end event for right censoring events.

Gender observation are useful for testing the grouping feature. There are 138 female patients and 90 male patients.

Survival analysis query requires cohorts saved by the user. Tables explore\_query\_results and saved\_cohorts are preloaded with the patient\_num of the 228 fake patients. The cohort identifier is -1 It is the default argument of the command.

Survival analysis example:

```text
docker-compose -f docker-compose.tools.yml run medco-cli-client --user test --password test srva  srva -l 2000 -g day  -s /SPHN/SPHNv2020.1/FophDiagnosis/ -e /SPHN/SPHNv2020.1/DeathStatus/ -y 126:1
```

