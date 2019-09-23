.. _lbl_configuration_keycloak:

Keycloak Configuration
----------------------

Here follows some MedCo-specific instructions for the administration of Keycloak. For anything else, please refer to the
`Keycloak Server Administration Guide <https://www.keycloak.org/docs/latest/server_admin/index.html>`_.


Accessing the web administration interface
''''''''''''''''''''''''''''''''''''''''''

In the case of the development profile *dev-local-3nodes* (i.e. without reverse proxy), the address is ``http://localhost:8081/auth/admin``.
In the other cases (with the reverse proxy), the address is ``http://<node domain name>/auth/admin``.
The credentials are :

- User ``keycloak``

- Password ``keycloak`` by default, or whatever else was configured at the initial deployment.


.. _lbl_configuration_keycloak_no_https:

Disabling HTTPS requirement for external connections
''''''''''''''''''''''''''''''''''''''''''''''''''''

When deploying the *test-local-3nodes* profile without HTTPS on a machine other than ``localhost``, the administration
interface will refuse to load. To solve this, access pgAdmin (see :ref:`lbl_configuration_postgresql`) and execute the
following SQL on the ``keycloak`` database:

.. code-block:: sql

    update REALM set ssl_required = 'NONE' where id = 'master';

You need to restart the Keycloak docker container to enable the changes. 


Import MedCo Default Settings
'''''''''''''''''''''''''''''

Import the provided realm configuration into Keycloak. This will create the MedCo client with the appropriate roles.

- Go to the *Import* menu
- Click on *Select file* and select the file ``keycloak-medco-realm.json`` that you will find in ``~/medco-deployment/resources/configuration``.


Configure the MedCo OpenID Connect client
'''''''''''''''''''''''''''''''''''''''''

In the *Settings* tab, fill *Valid Redirect URIs* according to the following table:

=================== =============================================
Deployment Profile  Valid Redirect URIs
=================== =============================================
*test-local-3nodes* ``http(s)://<node domain name>/glowing-bear``
*test-network*      ``https://<node domain name>/glowing-bear``
*dev-local-3nodes*  ``http://localhost:4200``
=================== =============================================

In the same tab, fill *Web Origins* with ``+`` and save.


User Management
'''''''''''''''

**Add a user**

- Go to the configuration panel *Users*, click on *Add user*.
- Fill the *Username* field, toggle to ``ON`` the *Email Verified* button and click *Save*.
- In the next window, click on *Credentials*, enter twice the user's password, toggle to ``OFF`` the *Temporary* button
  if desired and click *Reset Password*.


**Give query permissions to a user**

- Go to the configuration panel *Users*, search for the user you want to give authorization to and click on *Edit*.
- Go to the *Role Mappings* tab, and select *medco* (or another client ID set up for the MedCo OIDC client) in the *Client Roles*.
- Add the roles you wish to give the user, each of the roles maps to a query type.


