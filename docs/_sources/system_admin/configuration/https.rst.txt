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
from the *configuration profile* folder with your own versions. Such a certificate can be obtained for example through
`Let's Encrypt <https://letsencrypt.org/>`_.

Then edit the file ``.env`` from the *compose profile*, replace the ``http`` with ``https``, and restart the deployment.


Configure HTTPS for the Test Network Deployment
'''''''''''''''''''''''''''''''''''''''''''''''

For this profile, HTTPS is mandatory. The profile generation scripts generates and use default self-signed certificates
for each node. Those are perfectly fine to be used, but because they are self-signed, an HTTPS warning will be displayed
to users in their browser when accessing Glowing Bear. There are two ways of avoiding this warning:

- Configuring the browsers of your users to trust this certificate. This procedure is specific to the browsers and
  operating systems used at your site.
- Use a certificate obtained by an authority trusted by the browser you are using: see below.

If you wish to use a certificate from your own making, gather its key and the certificate itself. Note that using your
own certificate is only needed on the central node (as it is the one hosting the web application Glowing Bear). In the
*configuration profile* of the central node (``~/medco-deployment/configuration-profiles/test-network-<network name>-node<node index>/``)
copy the certificate and its key in the respective files ``certificate.crt`` and ``certificate.key``. Then duplicate the
file ``certificate.crt`` in ``srv0-certificate.crt``. Restart the deployment and the central node configuration is ready.

Now the other nodes need to get this certificate to trust it. Get and copy the ``srv0-certificate.crt`` file into each
of the *configuration profile* directory of the other nodes, and restart all the deployments. The configuration of HTTPS
is now ready.
