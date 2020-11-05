---
description: This is a small guide to make a new MedCo release.
---

# Release a new version

## Before releasing

### Update dependencies

#### Glowing Bear MedCo

* Update the Angular version
* Node version in docker image, has to be compatible with angular
* Angular version: 
* * NPM packages: `npm update` and review with `npm outdated`
  * `keycloak-js`: has to be the same version as Keycloak \(set in a `Dockerfile` in medco-deployment\)
  * `typescript`: has to be compatible with angular

#### Golang codebases: MedCo Connector, Unlynx, Loader

* `Dockerfile` go base image version: `FROM golang:1.13`
* go.mod go version: `go 1.13`
* Go modules \(pay particular attention to onet\): `go get -u ./...` and `go mod tidy`

#### Docker images in medco-deployment

* keycloak: check for db config dump

### Perform tests

locally with compiled dev versions from docker hub???



dev-local-3nodes: down and up, load v0, test + gb dev server

test-local-3nodes: same, but add this if has to be done locally:

```bash
I2B2_VERSION=dev
MEDCO_UNLYNX_VERSION=dev
NGINX_VERSION=dev
PGADMIN_VERSION=dev
KEYCLOAK_VERSION=dev
MEDCO_CONNECTOR_VERSION=dev
MEDCO_LOADER_VERSION=dev
GLOWING_BEAR_MEDCO_VERSION=dev
```

test-network: xxx test the script generates OK files, test deployment of one node, test run of cli-client



ensure CI of medco-deplyoment is OK + other repos

## Making a release

### Keep dependencies between codebases in sync

When the codebase is released, the version of the dependency should be an actual version \(like `v0.2.1`\), not a commit \(like `v0.2.2-0.20200131193353-88261e501a00`\). Because of this, the release for each go codebase should be done in a specific order:

* medco-unlynx -&gt; unlynx
* medco-loader -&gt; medco-unlynx, unlynx
* medco-connector -&gt; medco-loader, medco-unlynx, unlynx

### Updates in medco-deployment

* docker-compose-definitions.yml
* script config gen

### Release on GitHub

Version numbers follow [semantic versioning](https://semver.org/), and all codebases should have the same version. If a patch on a specific codebase is needed: 

PR on master / then tag new v

release on: medco-unlynx, medco-loader, medco-connector, glowing-bear-medco, medco-deployment

### Update documentation

#### In GitBook

* Create new variant named like the MedCo version being release \(e.g. `v1.0.0`\). When merged it will be pushed as a branch on GitHub.
* Update version numbers in the guides' download scripts \(e.g. `docker-compose pull`\).
* Review the documentation to ensure the guides are up-to-date. Notably the deployment and loading guides.
* Make the documentation variant be the new _main_ variant on GitBook.
* On GitHub, set the branch corresponding to the new version be the new default branch.
* release the doc through gitbook / put new default on gitbook / put new default branch on github

## After the release

* Ensure on Docker Hub that all images have been built correctly with the proper versioning.
* Update to the new version [the live demo on medco-demo.epfl.ch]().
* Update medco.epfl.ch website with the new version.
* Communication about the new release \(Twitter notably\).

