.. _lbl_configuration_keycloak:

Keycloak Configuration
----------------------

Here follows some MedCo-specific instructions for the administration of Keycloak.
For anything, please refer to the `Keycloak Server Administration Guide <https://www.keycloak.org/docs/latest/server_admin/index.html>`_.


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


Manually add an authorized user
'''''''''''''''''''''''''''''''

- Go to the configuration panel *Users*, click on *Add user*.
- Fill the *Username* field, toggle to ``ON`` the *Email Verified* button and click *Save*.
- In the next window, click on *Credentials*, enter twice the user's password, toggle to ``OFF`` the *Temporary* button
  if desired and click *Reset Password*.


Add the default OpenID Connect client configuration for MedCo
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

- Go to the configuration panel *Clients* and create a new client.
- There specify in *Client ID* the value ``medco`` (or another value if previously configured) and save.
- In the next window (the *Settings* tab), fill *Valid Redirect URIs* according to the following table.

=================== =============================================
Deployment Profile  Valid Redirect URIs
=================== =============================================
*test-local-3nodes* ``http(s)://<node domain name>/glowing-bear``
*test-network*      ``https://<node domain name>/glowing-bear``
*dev-local-3nodes*  ``http://localhost:4200``
=================== =============================================

- In the same tab, fill *Web Origins* with ``+`` and save.
- In the *Mappers* tab, create a new mapper, fill the following: *Name*: ``MedCo Audience``, *Mapper Type*: ``Audience``,
  *Included Client Audience*: ``medco`` and save.
