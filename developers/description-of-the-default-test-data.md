# Description of the default test data

## MedCo Explore

The default data loaded in MedCo is a small artificially generated dataset, appropriate to test a fresh deployment. The same data is replicated on all the nodes. Note that as of now it is encrypted using the test keys, i.e. the ones used for deployment profiles `dev-local-3nodes` and `test-local-3nodes`.

It contains 4 patients: 1 \(real\), 2 \(real\), 3 \(real\), 4 \(dummy\).

3 encrypted concepts: 1, 2, 3.

1 clear concept folder: /E2ETEST/e2etest/.

4 clear concepts:  /E2ETEST/e2etest/1/,  /E2ETEST/e2etest/2/, /E2ETEST/e2etest/3/.

1 modifier folder: /E2ETEST/modifiers/.

3 modifiers: /E2ETEST/modifiers/1/, E2ETEST/modifiers/2/, E2ETEST/modifiers/3/.

The observation fact contains the following entries:

* patient 1, concept 1
* patient 1, concept /E2ETEST/e2etest/1/ \(val=10\), modifier /E2ETEST/modifiers/1/ \(val=10\)
* patient 2, concept 1
* patient 2, concept 2
* patient 2, concept /E2ETEST/e2etest/1/ \(val=20\), modifier /E2ETEST/modifiers/ \(val=20\)
* patient 2, concept /E2ETEST/e2etest/2/\(val=50\), modifier /E2ETEST/modifiers/2/\(val=5\)
* patient 3, concept 2
* patient 3, concept 3
* patient 3, concept /E2ETEST/e2etest/1/ \(val=30\), modifier /E2ETEST/modifiers/ \(val=15\), modifier /E2ETEST/modifiers/1/ \(val=15\)
* patient 3, concept /E2ETEST/e2etest/2/ \(val=25\), modifier /E2ETEST/modifiers/ \(val=30\), modifier /E2ETEST/modifiers/2/ \(val=15\)
* patient 3, concept /E2ETEST/e2etest/3/ \(val=77\), modifier /E2ETEST/modifiers/ \(val=66\), modifier /E2ETEST/modifiers/3/ \(val=88\)
* patient 4, concept 1
* patient 4, concept 2
* patient 4, concept 3
* patient 4, concept /E2ETEST/e2etest/3/ \(val=20\), modifier /E2ETEST/modifiers/3/ \(val=10\)

Example queries and expected results \(per node\):

* `enc::1 AND enc::2`: 1 \(patient 2\)
* `enc::2 AND enc::3`: 1 \(patient 3\)
* `enc::1 AND enc::2 AND enc::3`: 0
* `enc::1 OR enc::2`: 3 \(patients 1, 2 and 3\)
* `enc::1 OR enc::3 AND enc::2`: 1 \(patients 2 and 3\)
* `clr::/E2ETEST/e2etest/1/`: 3 \(patients 1, 2 and 3\)
* `clr::/E2ETEST/e2etest/1/:/E2ETEST/modifiers/:/e2etest/%`: 3 \(patients 1, 2 and 3\)
* `clr::/E2ETEST/e2etest/1/:/E2ETEST/modifiers/1/:/e2etest/1/`: 2 \(patients 1 and 3\)
* `enc::1 AND clr::/E2ETEST/e2etest/2/`: 1 \(patient 2\)
* `enc::1 OR clr::/E2ETEST/e2etest/3/`:  3 \(patients 1, 2 and 3\)
* `clr::/E2ETEST/e2etest/1/::EQ:10`: 1 \(patient 1\)
* `clr::/E2ETEST/e2etest/1/:/E2ETEST/modifiers/1/:/e2etest/1/::EQ:15`: 1 \(patient 3\)
* `clr::/E2ETEST/e2etest/1/::BETWEEN:5 and 25`: 2 \(patients 1 and 2\)
* `enc::1 OR clr::/E2ETEST/e2etest/2/::GE:25 AND clr::/E2ETEST/e2etest/2/:/E2ETEST/modifiers/2/:/e2etest/2/::LT:21`: 2 \(2 and 3\)

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

