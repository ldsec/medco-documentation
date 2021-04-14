# Database

## Administration with PgAdmin

PgAdmin can be accessed through `http(s)://<node domain name>/pgadmin` with username `admin` and password `admin` \(by default\). To access the test database just create a server with the name `MedCo`, the address `postgresql`, username `postgres` and password `postgres` \(by default\). Note that PgAdmin is not included in the production deployments.

![PgAdmin server configuration.](../.gitbook/assets/pgadmin.png)

## Managing Large Databases: Data Loading <a id="loading"></a>

### Database modifications

```sql
-- structure
ALTER TABLE i2b2demodata_i2b2.observation_fact
    ALTER COLUMN instance_num TYPE bigint,
    ALTER COLUMN text_search TYPE bigint;
    
-- settings
ALTER SYSTEM SET maintenance_work_mem TO '32GB';
SELECT pg_reload_conf();
```

### Data generation

All the following operations are implemented through PL/pgSQL functions present in the MedCo-i2b2 database.

#### Duplication

The parameter of the following functions corresponds to the number of times the existing `observation_fact` table should be added to itself. For example with 3 , the number of rows of the table will be multiplied by 4.

* Method 1 \(double for loop\)

```sql
SELECT i2b2demodata_i2b2.obs_fact_duplication_method_1(3);
```

* Method 2 \(temporary table\)

```sql
SELECT i2b2demodata_i2b2.obs_fact_duplication_method_2(3);
```

#### Reduction

The parameter of the following function corresponds to the number of rows the resulting `observation_fact` table will have.

```sql
SELECT i2b2demodata_i2b2.obs_fact_reduction(2370000000);
```

#### Indexes

The following command builds only the i2b2 indexes needed by MedCo. I2b2 offers by default more of them to enable features not currently supported by MedCo.

```sql
SELECT i2b2demodata_i2b2.obs_fact_indexes();
```

### MedCo setup

#### PostgreSQL database files

In the `docker-compose.common.yml` of the running profile, add in the `postgresql` service the following key, pointing to where the database files are:

```yaml
volumes:
  - PATH_TO_DATABASE_FILES/_data:/var/lib/postgresql/data
```

#### Timeouts

Depending on the size of the database, you might need to increase several timeouts, notably the following:

* `I2B2_WAIT_TIME_SECONDS`
* `SERVER_HTTP_WRITE_TIMEOUT_SECONDS`
* `CLIENT_QUERY_TIMEOUT_SECONDS`
* `ALL_TIMEOUTS_SECONDS`

## Backed Up Data <a id="backed-up-data"></a>

### Backup Server <a id="backup-server"></a>

* SSH: icsil1-ds-49.epfl.ch ; accounts: root / lca1
* SSH Key of Mickaël and Joao set up \(ask one of them for access\)
* 20TB storage in `/srv/`, publicly accessible read-only through rsync daemon
* 10Gbps link with IC Clusters through interface 10.90.48.141

### Data Stored in `/srv/` <a id="data-stored-in-srv"></a>

#### `/srv/databases` <a id="srv-databases"></a>

* `pg_volume_nodeX_x1212_indexes`  Databases of 3 nodes \(`X=0,1,2`\), with approximately 150k patients and 28.5B records total \(50k patients and 9.5B records per node\). It is a x1212 duplication of the original `tcga_bio` dataset. It also contains the built indexes. The size of each is around 3TB, which maybe can be reduced by running a PostgreSQL FULL VACUUM.
* `pg_volume_node0_XB_indexes`  Those databases are reductions of the `pg_volume_node0_x1212_indexes` database, with `X=4.75,3.17,2.37` billion records. Those numbers were calculated to keep a total number of 28.5B rows with respectively 6, 9 and 12 nodes.

#### `/srv/deployments` <a id="srv-deployments"></a>

* `icclusters-deployment-backup-11-07-19`  Contains all the deployment profiles and keys used for the `pg_volume_nodeX_x1212_indexes` databases.
* `postgresql-deployment`  Local deployment of postgresql and pgAdmin, in order to explore or modify the databases.
* `nebulaexp-alldeployments`  Contains all the deployment profiles and keys used for the `pg_volume_node0_XB_indexes` databases.

#### `/srv/logs` <a id="srv-logs"></a>

* `duplications-nodeX`  Logs of data duplication \(x100, x2, x3\) and indexes building for the `pg_volume_nodeX_x1212_indexes` databases.
* `reductions-node0`  Logs of data reduction \(to 2.37B records\) and indexes building of `pg_volume_node0_x1212_indexes` database.

### Copying data to/from IC-Cluster machines <a id="copying-data-to-from-ic-cluster-machines"></a>

#### Enabling rsync daemon on a linux machine <a id="enabling-rsync-daemon-on-a-linux-machine"></a>

Using the rsync daemon allows for easier data copy between machines. It is already enabled on the backup server \(read-only\), but in some cases it can be useful on other machines.

 In the file `/etc/default/rsync` set the variable: `RSYNC_ENABLE=true`. Create the file `/etc/rsyncd.conf` with the following content, adapted to your case:

```text
uid = root
gid = root

[disk]
path = /disk/
comment = MedCo data (read-only)
read only = yes
```

Then start the daemon with `service rsync start`.

#### Copy data with rsync <a id="copy-data-with-rsync"></a>

Example from an IC Cluster machine: `rsync -a -v rsync://10.90.48.141/srv/databases/pg_volume_node0_x1212_indexes /disk/pg_volume`



