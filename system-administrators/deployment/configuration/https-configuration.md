# HTTPS Configuration

HTTPS is supported for the profiles _test-local-3nodes_, _test-network_ and _prod-network_.

### Certificate

The certificates are held in the configuration profile folder \(e.g, `${MEDCO_SETUP_DIR}/configuration-profiles/test-local-3nodes`\):

* _certificate.key_: private key
* _certificate.crt_: certificate of own node
* _srv0-certificate.crt_, _srv1-certificate.crt_, …: certificates of all nodes of the network

### Enable HTTPS for the Local Local Deployment

To enable HTTPS for the profile _test-local-3nodes_, replace the files _certificate.key_ and _certificate.crt_ from the _configuration profile_ folder with your own versions. Such a certificate can be obtained for example through [Let’s Encrypt](https://letsencrypt.org/).

Then edit the file `.env` from the _compose profile_, replace the `http` with `https`, and restart the deployment.

### Configure HTTPS for the Network Test and Production Deployments

For these profiles, HTTPS is mandatory. The profile generation scripts generate and use default self-signed certificates for each node. Those are perfectly fine to be used, but because they are self-signed, an HTTPS warning will be displayed to users in their browser when accessing one of the Glowing Bear instance.

There is currently only one way of avoiding this warning: configuring the browsers of your users to trust this certificate. This procedure is specific to the browsers and operating systems used at your site.

{% hint style="info" %}
In MedCo v1.0.0 the possibility of using your own trusted certificates will be added.
{% endhint %}

