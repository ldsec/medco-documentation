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

### Corrupt deployment after interrupting the very first loading

The very first a deployment is started, an initialization phase that can some time \(2-10 minutes depending on the machine\) will take place. If during this initialization the deployment is stopped, the database will be left in a corrupt state. In order to reset the database, you should delete the corresponding docker volume:

```bash
docker volume rm dev-local-3nodes_medcodb
```

Note that the name of volume in this example is valid only for the dev-local-3nodes deployment. In other cases, use `docker volume ls` to retrieve the name of the volume containing the database, usually in the format `<deploymentprofile>_medcodb`.

