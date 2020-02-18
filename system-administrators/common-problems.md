# Common Problems

## Docker-related issues

### Changing the Docker default address pool

If after deploying MedCo you notice some connectivity problems on your machine, or on the opposite the running containers have connectivity problems, check for potential conflict between your machine networks and Docker's virtual network \(e.g. with `ifconfig`\). If you do have such conflicts, you can edit Docker's configuration to set the addresses to use. Example:

{% code title="/etc/docker/daemon.json" %}
```javascript
{
  "default-address-pools": [{
      "base": "10.10.0.0/16",
      "size": 24
  }]
}
```
{% endcode %}

### Using Docker as non-root user

If you get such an error message while trying to execute commands as a non-root user:

```text
docker: Got permission denied while trying to connect to the Docker daemon socket at ...
```

You will need to follow [these instructions from the Docker official documentation](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user).

