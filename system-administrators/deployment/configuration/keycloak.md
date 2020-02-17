# Keycloak

Here follows some MedCo-specific instructions for the administration of Keycloak. For anything else, please refer to the [Keycloak Server Administration Guide](https://www.keycloak.org/docs/latest/server_admin/index.html).

{% hint style="danger" %}
For a production deployment, it is crucial to change the default keys and credentials.
{% endhint %}

## Accessing the web administration interface

You can access the Keycloak administration interface at `http(s)://<node domain name>/auth/admin`. For example if MedCo is deployed on your local host, you can access it at `http://localhost/auth/admin`. Use the admin default credentials if you had just deployed MedCo.

## User Management

### Default users

The default configuration shipped with the MedCo deployments come with two users.

#### Admin user

The default admin credentials has all the admin access to Keycloak, but no access rights to MedCo. Its credentials are :

* User `keycloak`
* Password `keycloak` \(unless configured otherwise through the `.env` file\)

#### Test user

The default MedCo user has all the authorizations to run all types of MedCo query. It is this user you should use to log in MedCo. Its credentials are:

* User `test`
* Password `test`

### **Add a user**

* Go to the configuration panel _Users_, click on _Add user_.
* Fill the _Username_ field, toggle to `ON` the _Email Verified_ button and click _Save_.
* In the next window, click on _Credentials_, enter twice the user’s password, toggle to `OFF` the _Temporary_ button if desired and click _Reset Password_.

### **Give query permissions to a user**

* Go to the configuration panel _Users_, search for the user you want to give authorization to and click on _Edit_.
* Go to the _Role Mappings_ tab, and select _medco_ \(or another client ID set up for the MedCo OIDC client\) in the _Client Roles_.
* Add the roles you wish to give the user, each of the roles maps to a query type.

## MedCo Default Settings

### _medco_ OpenID Connect client

The default Keycloak configuration provides an example of a fully working configuration for deployments on your local host. In other cases, you will need to modify this configuration.

Access the configuration panel of the MedCo client by going to the _Clients_ tab, and click on the _medco_ client. The, in the _Settings_ tab, fill _Valid Redirect URIs_ to reflect the following table:

| Deployment Profile | Valid Redirect URIs |
| :--- | :--- |
| _test-local-3nodes_ | `http(s)://<node domain name>/*` |
| _test-network + prod-network_ | `https://<node domain name>/*` |
| _dev-local-3nodes_ | `http://localhost:4200/*` |

In the same tab, fill _Web Origins_ with `+` and save.

## Securing a production deployment

### Changing default passwords

Both `keycloak` and `test` users comes with default passwords. For a production deployment they need to be changed:

* Go to the configuration panel _Users_, click on _View all users_.
* For each of the users you want to change the password of:
  * Click on _Edit_, then go the _Credentials_ tab.
  * Enter the new password of the user
  * Optionally toggle to `OFF` the _Temporary_ button; if `ON` the user at the next login will need to update his password.
  * Click on _Reset Password_.

### Changing default realm keys

The example configuration comes with default keys. They have to be changed for a network deployment where there are several Keycloak instances.

* Go to the configuration panel _Realm Settings_, then to the _Keys_ tab and _Providers_ subtab.
* Click on _Add keystore..._ and add the three following providers:
  * _aes-generated_
    * _Console Display Name_: `aes-medco`
    * _Priority_: `100`
  * _hmac-generated_
    * _Console Display Name_: `hmac-medco`
    * _Priority_: `100`
* * _rsa-generated_
    * _Console Display Name_: `rsa-medco`
    * _Priority_: `100`
* Finally, delete **all the other key providers** listed that you did not just add. They should be named _xxx-generated_. Note that it is normal if you get logged out during the operation, just log back in and continue the process.

### Enabling brute force detection

* Go to the configuration panel _Realm Settings_, then to the _Security Defenses_ tab and _Brute Force Detection_ subtab.
* Toggle to `ON` the _Enabled_ button.
* Fill the following:
  * _Max Login Failures_: `3`
  * _Wait Increment_: `30 Seconds`
  * _Save_ the configuration.

## \_\_



