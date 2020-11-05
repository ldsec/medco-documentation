# Passwords

{% hint style="danger" %}
It is important to choose strong unique passwords before a deployment, even more so if it contains real data or if it is exposed to the internet.
{% endhint %}

## Passwords Configuration

In each _compose profile_ you will find a `.env` file containing configuration options. Among them are the passwords to be set. Note that most of those passwords configured that way will only work on a fresh database. Example:

```bash
POSTGRES_PASSWORD=postgres_password
PGADMIN_PASSWORD=pgadmin_password
KEYCLOAK_PASSWORD=keycloak_password
I2B2_WILDFLY_PASSWORD=i2b2_wildfly_password
I2B2_SERVICE_PASSWORD=i2b2_service_password
I2B2_USER_PASSWORD=i2b2_user_password
```

### PostgreSQL administration user

`POSTGRES_PASSWORD` configures the password for the `postgres` administration user of the PostgreSQL database.

### PgAdmin user

`PGADMIN_PASSWORD` configures the password for the `admin` user of the PgAdmin web interface. Note that it is necessary to set it only if your deployment profile deploys this tool.

### Keycloak administration user

`KEYCLOAK_PASSWORD` configures the password for the `keycloak` administration user of the default `master` realm of Keycloak.

{% hint style="warning" %}
As of v1.0.0, the provisioning of the configuration of Keycloak has changed and this setting is not effective. After the initial deployment, you **must** login to the administration interface with the default password \(`keycloak`\) and change it.
{% endhint %}

### I2b2 Wildfly administration user

`I2B2_WILDFLY_PASSWORD` configures the password for the `admin` user of the wildfly instance hosting i2b2.

### I2b2 service user

`I2B2_SERVICE_PASSWORD` configures the password for the `AGG_SERVICE_ACCOUNT` user of i2b2, used to operate background automated tasks by the i2b2 services.

### I2b2 default user

`I2B2_USER_PASSWORD` configures the password for the default `i2b2` and `demo` users used by MedCo.

