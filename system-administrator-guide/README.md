# System Administrator Guide

This guide explains the deployment and configuration of MedCo instances.

* [Specifications](specifications.md)
* [Deployment](deployment/)
  * [Local Test Deployment](deployment/local-test-deployment.md)
    * [MedCo Stack Deployment](deployment/local-test-deployment.md#medco-stack-deployment)
    * [Keycloak Configuration](deployment/local-test-deployment.md#keycloak-configuration)
    * [Test the deployment](deployment/local-test-deployment.md#test-the-deployment)
  * [Network Test Deployment](deployment/network-test-deployment.md)
    * [Preliminaries](deployment/network-test-deployment.md#preliminaries)
    * [Generation of the Deployment Profile](deployment/network-test-deployment.md#generation-of-the-deployment-profile)
    * [MedCo Stack Deployment](deployment/network-test-deployment.md#medco-stack-deployment)
    * [Keycloak Configuration](deployment/network-test-deployment.md#keycloak-configuration)
    * [Data Loading](deployment/network-test-deployment.md#data-loading)
    * [Test the deployment](deployment/network-test-deployment.md#test-the-deployment)
  * [Local Development Deployment](deployment/local-development-deployment.md)
    * [MedCo Stack Deployment \(except Glowing Bear\)](deployment/local-development-deployment.md#medco-stack-deployment-except-glowing-bear)
    * [Glowing Bear Deployment](deployment/local-development-deployment.md#glowing-bear-deployment)
    * [Keycloak Configuration](deployment/local-development-deployment.md#keycloak-configuration)
    * [Test the deployment](deployment/local-development-deployment.md#test-the-deployment)
  * [Deployment Profiles](deployment/#deployment-profiles)
* [Configuration](configuration/)
  * [Keycloak Configuration](configuration/keycloak-configuration.md)
    * [Accessing the web administration interface](configuration/keycloak-configuration.md#accessing-the-web-administration-interface)
    * [Disabling HTTPS requirement for external connections](configuration/keycloak-configuration.md#disabling-https-requirement-for-external-connections)
    * [Import MedCo Default Settings](configuration/keycloak-configuration.md#import-medco-default-settings)
    * [Configure the MedCo OpenID Connect client](configuration/keycloak-configuration.md#configure-the-medco-openid-connect-client)
    * [User Management](configuration/keycloak-configuration.md#user-management)
  * [HTTPS Configuration](configuration/https-configuration.md)
    * [Certificate](configuration/https-configuration.md#certificate)
    * [Enable HTTPS for the Test Local Deployment](configuration/https-configuration.md#enable-https-for-the-test-local-deployment)
    * [Configure HTTPS for the Test Network Deployment](configuration/https-configuration.md#configure-https-for-the-test-network-deployment)
  * [The PostgreSQL database](configuration/the-postgresql-database.md)
    * [Administration with PgAdmin](configuration/the-postgresql-database.md#administration-with-pgadmin)
* [Loading Data](loading-data/)
  * [v0 \(Genomic Data\)](loading-data/v0-genomic-data.md)
    * [Example](loading-data/v0-genomic-data.md#example)
    * [Data Manipulation](loading-data/v0-genomic-data.md#data-manipulation)
  * [v1 \(I2B2 Demodata\)](loading-data/v1-i2b2-demodata.md)
    * [Dummy Generation](loading-data/v1-i2b2-demodata.md#dummy-generation)
    * [Example](loading-data/v1-i2b2-demodata.md#example)
  * [Pre-Requisites](loading-data/#pre-requisites)
* [Network Architecture](network-architecture.md)
  * [External Entities](network-architecture.md#external-entities)
  * [Firewall Ports Opening](network-architecture.md#firewall-ports-opening)
