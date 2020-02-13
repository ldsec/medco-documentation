# Description of the default test data

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

Example queries and expected results:

* 1 AND 2: 1 \(patient 2\)
* 2 AND 3: 1 \(patient 3\)
* 1 AND 2 AND 3: 0
* \(1 OR 2\): 3 \(patients 1, 2 and 3\)
* \(1 OR 3\) AND 2: 1 \(patients 2 and 3\) 

