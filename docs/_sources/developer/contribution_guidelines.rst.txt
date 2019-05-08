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

*master*: stable branch, always points to the latest release
*dev*: development branch, merged into *master*

have designated code owners (they have the responsibility of dev)

tag through github (will trigger docker hub build) "draft new release", auto tag create


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

update versions in medco-doicuemntaiton

WARNING: tag AFTER the PR (if not annoying problems -> tag it directly on github and not on CLI)
or not? check...

all repos have same version number, but can differ in terms of letters
a

do release with tags x.x.x-rcZ
test the test-3nodes-local manueally (+test network)
increment Z as needed
then release final without rc

to do rc locally: docker-compose build the common file
then in other repos (GB, medco-unlyncx, medco-loader, medco-connectpor)
build and tag manually!
medco-loader: do separately after, so that dependency on medco-unlynx version can be adapted

update version of medco-unlynx used!
create tag from github web interface on master
update medco-doc

in definitions: put rcX tag, build them manually
< procedure for different profiles



versionning: semantic versionning across components
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


dev workflow:
build images in independenat repos (will put dev tag)
build from definitions form others


RC for tests: how
