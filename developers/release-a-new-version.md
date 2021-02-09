---
description: This is a small guide to make a new MedCo release.
---

# Release a new version

## Before releasing

### Update dependencies

#### Glowing Bear MedCo

* Update the Angular version and ensure node version in docker image is compatible with angular
* NPM packages: `npm update` and review with `npm outdated`
  * `keycloak-js`: has to be the same version as Keycloak \(set in a `Dockerfile` in medco-deployment\)
  * `typescript`: has to be compatible with the angular version used

#### MedCo

* `Dockerfile` go base image version: `FROM golang:1.13`
* go.mod go version: `go 1.13`
* Go modules \(pay particular attention to onet\): `go get -u ./...` and `go mod tidy`

### Perform tests

* Check that all the CI/CD pipeline on GitHub passes \(this tests the whole backend with the profile _dev-local-3nodes_\)
* Deploy locally _test-local-3nodes_ to manually test Glowing Bear MedCo
* Deploy locally on several machines _test-network_ to manually test the deployment over several machines, and the generation of its configuration

To change the version of the docker images used, update the `.env` file in the deployment folder:

```bash
MEDCO_VERSION=<docker_tag>
GLOWING_BEAR_MEDCO_VERSION=<docker_tag>
```

## Making a release

### Manual updates

* Update the version of Glowing Bear MedCo `GB_VERSION` in the `Makefile` to point to the correct Docker tag that will be released \(e.g. v1.0.0\)

### Release on GitHub

Version numbers follow [semantic versioning](https://semver.org/), and both codebases should have the same version. For both codebases:

* Out of the `dev` branch, create a PR onto `master` on GitHub and merge it
* Out of the `master` branch, create a new release \(and the associated tag\) with the semantic version \(e.g. v1.0.0\)
* Ensure the CI/CD pipeline correctly builds the new release

### Update documentation

#### In GitBook

* Create new variant named like the MedCo version being release \(e.g. `v1.0.0`\). When merged it will be pushed as a branch on GitHub.
* Update version numbers in the guides' download scripts \(e.g. `docker-compose pull`\).
* Review the documentation to ensure the guides are up-to-date. Notably the deployment and loading guides.
* Make the documentation variant be the new _main_ variant on GitBook.
* On GitHub, set the branch corresponding to the new version be the new default branch.

## After the release

* Ensure on GitHub that all images have been built correctly with the proper versioning.
* Update to the new version [the live demo on medco-demo.epfl.ch](live-demo.md).
* Update medco.epfl.ch website with the new version and update the roadmap.
* Communication about the new release \(Twitter notably\).



