# Keycloak



Here follows some MedCo-specific instructions for the administration of Keycloak. For anything else, please refer to the [Keycloak Server Administration Guide](https://www.keycloak.org/docs/latest/server_admin/index.html).

TODO: add section about changing default keys

{% hint style="danger" %}
For a production deployment, it is crucial to change the default keys and credentials.
{% endhint %}

### Accessing the web administration interface

In the case of the development profile _dev-local-3nodes_ \(i.e. without reverse proxy\), the address is `http://localhost:8081/auth/admin`. In the other cases \(with the reverse proxy\), the address is `http://<node domain name>/auth/admin`. The credentials are :

* User `keycloak`
* Password `keycloak` by default, or whatever else was configured at the initial deployment.

### Disabling HTTPS requirement for external connections

REMOVE ME

When deploying the _test-local-3nodes_ profile without HTTPS on a machine other than `localhost`, the administration interface will refuse to load. To solve this, access pgAdmin \(see [The PostgreSQL database](the-postgresql-database.md)\) and execute the following SQL on the `keycloak` database:

```text
update REALM set ssl_required = 'NONE' where id = 'master';
```

You need to restart the Keycloak docker container to enable the changes.

### Import MedCo Default Settings

Import the provided realm configuration into Keycloak. This will create the MedCo client with the appropriate roles.

* Go to the _Import_ menu
* Click on _Select file_ and select the file `keycloak-medco-realm.json` that you will find in `~/medco-deployment/resources/configuration`.
* Select to import everything, and to _Skip_ if resources already exist

### Configure the MedCo OpenID Connect client

Access the configuration panel of the MedCo client by going to the _Clients_ tab, and click on the _medco_ client. The, in the _Settings_ tab, fill _Valid Redirect URIs_ according to the following table:

| Deployment Profile | Valid Redirect URIs |
| :--- | :--- |
| _test-local-3nodes_ | `http(s)://<node domain name>/glowing-bear` |
| _test-network_ | `https://<node domain name>/glowing-bear` |
| _dev-local-3nodes_ | `http://localhost:4200` |

In the same tab, fill _Web Origins_ with `+` and save.

### User Management

TODO: add info about default credentials and how to change them etc test + keycloak

**Add a user**

* Go to the configuration panel _Users_, click on _Add user_.
* Fill the _Username_ field, toggle to `ON` the _Email Verified_ button and click _Save_.
* In the next window, click on _Credentials_, enter twice the user’s password, toggle to `OFF` the _Temporary_ button if desired and click _Reset Password_.

**Give query permissions to a user**

* Go to the configuration panel _Users_, search for the user you want to give authorization to and click on _Edit_.
* Go to the _Role Mappings_ tab, and select _medco_ \(or another client ID set up for the MedCo OIDC client\) in the _Client Roles_.
* Add the roles you wish to give the user, each of the roles maps to a query type.

