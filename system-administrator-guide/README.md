# System Administrator Guide

This guide explains the deployment and configuration of MedCo instances according to different scenarios.

## Specifications

We recommend the following specifications for running MedCo:

* **Network Bandwidth**: &gt;100 Mbps \(ideal\), &gt;10 Mbps \(minimum\), symmetrical
* **Ports Opening and IP Restrictions**: see [Network Architecture](network-architecture.md)
* **Hardware**
  * **CPU**: 8 cores \(ideal\), 4 cores \(minimum\)
  * **RAM**: &gt;16 GB \(ideal\), &gt;8GB \(minimum\)
  * **Storage**: dependent on data loaded, &gt;100GB
* **Software**
  * **OS**: Any flavor of Linux, physical or virtualized \(tested with Ubuntu 16.04, 18.04, Fedora 29\)
  * **Softwares**: OpenSSL, [Docker](https://docs.docker.com/install/) \(tested with Docker 18.09.1\) & [Docker-Compose](https://docs.docker.com/compose/install/) \(tested with Docker-Compose 1.23.2\).

