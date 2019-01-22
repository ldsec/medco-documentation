Contribution Guidelines
=======================

Repositories Organisation
-------------------------

Code repositories:
    - *dev* branch: active development
    - *master* branch: releases

Tags:
    - v*x*.*y*.*zL*
*x.y.z*: MedCo version
*L*: letter(s) to indicate revision of a version
all versions are on docker cloud as well (built as images)


Code organization:
    - *deployment* folder: contains the deployment related stuff


binaries always hosted somewhere: on docker cloud or on npmjs



Making a Release
----------------
git tag -a MedCo-v0.1b -m "MedCo-v0.1b"
git push --tags

- tag repos
- ensure build on docker cloud
- doc conf.py
- medco-deployment: put versions in compose (for prod)
- docker cloud: /^v([0-9.]+)$/
- todo: add the letters for revisions /^v([a-z0-9.]+)$/
- docker compose update versions
- bin: medco-deployment on github, other on docker hub
https://github.com/lca1/medco-deployment/releases/tag/v0.1 : have text at index of doc matching the one on github release (and list)
+ is a pre-release

update version in medco-doicuemntaiton


all repos have same version number, but can differ in terms of letters

docker cloud conf
-----------------
Docker Tag
Source
Build Status

dev
dev
EMPTY

latest
master
SUCCESS

{sourceref}
/^(v[0-9.]+[a-z]*)$/
SUCCESS
