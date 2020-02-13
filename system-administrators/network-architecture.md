# Network Architecture

![../\_images/network\_architecture.png](https://medco.epfl.ch/documentation/_images/network_architecture.png)

### External Entities

Entities that need to connect to a machine running MedCo can be categorized as follow:

> * **System administrators**: Persons administrating the MedCo node. Likely to remain inside the clinical site internal network.
> * **End-users**: Researchers using MedCo to access the shared. Likely to remain inside the clinical site internal network.
> * **Other MedCo nodes**: MedCo nodes belonging to other clinical sites of the network.

### Firewall Ports Opening

The following ports should be accessible by the listed entities, which makes IP address white-listing possible:

> * Port 22, 5432 \(TCP\): _System Administrators_
> * Port 80 \(TCP\): _End-Users_ \(HTTP automatic redirect to HTTPS \(443\)\)
> * Port 443 \(TCP\): _System Administrators_, _End-Users_, _Other MedCo Nodes_
> * Ports 2000-2001 \(TCP\): _Other MedCo Nodes_

