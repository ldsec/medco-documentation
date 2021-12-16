---
This tutorial describes how to build a specific version of medco for the test-local-3nodes configuration locally. 
Normally the test-local-3nodes deployment profile pulls docker images hosted on a remote server. 
By following the following tutorial one is able to select specific commits from the development history of glowing-bear and the back-end from a local machine,
 build the docker images for those specific versions of medco, and then use those images to deploy a test-local-3nodes profile for testing purposes.
---

# Local Development Deployment with test-local-3nodes profile

{% hint style="danger" %}
This deployment profile comes with default pre-generated keys and password. It is not meant to contain any real data nor be used in production. If you wish to do so, use instead the [Network Deployment \(network\)](../system-administrators/deployment/network-deployment.md) deployment profile.
{% endhint %}

This deployment profile deploys 3 MedCo nodes on a single machine for testing purposes.

## Building the docker images locally:

### Building the docker image for the backend:

Enter the directory containing the local version of the glowing-bear repository on the computer where you will deploy the software. 
The first step is to select the commit for which one wants a docker image to be built.
Once this is done go to the deployments/dev-local-3nodes/ directory and run the `make build` command. This will build a docker image with the following title:

```
name:				tag:
medco/glowing-bear-medco	dev 
```

You can check if this image exists by running `docker image ls`.


### Building the docker image for the front-end (glowing bear):

The aim of this section is similar to the previous one, that is build a docker image (this time for the front-end). But there exists some subtleties.
Enter the directory containing the front-end repository on the computer where you will deploy the software. Select the commit for which you are interested to build a docker image.
In the `deployment` directory create a bash file containing the following content:

```
#!/usr/bin/env sh
USER_GROUP="$(id -u):$(id -g)" docker-compose build glowing-bear-medco
docker image tag medco/glowing-bear-medco:dev ghcr.io/ldsec/glowing-bear-medco:dev
```

Execute the bash file, this will build a docker image for the glowing-bear project for the specific commit you selected. 
By default the docker image is attributed a name that is problematic for the following steps (deployment of the test-local-3nodes profile), 
so we rename the version with the second bash instruction contained in the file.


## Using the docker images built locally and running the server:

### Changing the content of the Makefile:
Move to the backend repository on the computer used as a server.
In the Makefile (deployments/test-local-3nodes/Makefile) change the content of the two variables like described below:

```
export MEDCO_VERSION := dev
export GLOWING_BEAR_MEDCO_VERSION := dev
```

If you want to configure https (certificates), server remote clients you should follow the instructions on that matter on the documentation linked to the test-local-3nodes profile.

### Running the server
Once you have configured the deployment profile like desired, you will be ready to run the server with the following command executed from the deployments/test-local-3nodes directory:
```
make up
```


