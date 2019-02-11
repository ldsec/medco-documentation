.. _lbl_configuration_https:

HTTPS Configuration
-------------------

HTTPS is supported for the profiles *test-local-3nodes* and *test-network*.


Certificate
'''''''''''
The certificates are held in the configuration profile folder (e.g, ``~/medco-deployment/configuration-profiles/test-local-3nodes``):

- *certificate.key*: private key
- *certificate.crt*: certificate of own node
- *srv0-certificate.crt*, *srv1-certificate.crt*, ...: certificates of all nodes of the network


Enable HTTPS for the Test Local Deployment
''''''''''''''''''''''''''''''''''''''''''

To enable HTTPS for the profile *test-local-3nodes*, replace the files *certificate.key* and *certificate.crt*
from the *configuration profile* folder with your own versions.
Such a certificate can be obtained for example through `Let's Encrypt <https://letsencrypt.org/>`_.

Then edit the file ``.env`` from the *compose profile*, replace the ``http`` with ``https``, and restart the deployment.


Configure HTTPS for the Test Network Deployment
'''''''''''''''''''''''''''''''''''''''''''''''

*Coming soon*