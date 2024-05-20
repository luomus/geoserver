# FinBIF Geoserver

# Deployment

The instance is designed to be deployed to OpenShift v4

Use the script `oc-process.sh` the project objects and pipe them to the Openshift command line tool `oc`.

For example:

```sh
oc login ... # copy token from Openshift web UI
./oc-process.sh -f template.yml -e .env -i volume-app | oc create -f -
```

The `.env` file should contain appropriate values for the following variables:

```sh
HOST=
DEV_HOST=
DB_PASSWORD=
DEV_DB_PASSWORD=
RCLONE_ACCESS_KEY_ID=
RCLONE_SECRET_ACCESS_KEY=
OBJECT_STORE= # An existing object store container name found at the location specified in `rclone.conf` 
```

## Database 

A new PostGIS database instance will require adjustments to the files `postgresql.conf` and `pg_hba.conf`.

First use `oc rsync` to make local copies of the two files.

```sh
mkdir db
oc login ...
oc get pods # Get name of PostGIS pod and replace in next line
oc rsync --exclude="*" --include="pg_hba.conf" --include="postgresql.conf" <POD_NAME>:/var/lib/postgresql/data/pgdata/ db/
```

In `postgresql.conf` replace the line:

```sh
#shared_preload_libraries = ''
```

with 

```sh
shared_preload_libraries = 'pgaudit'
```

and `pg_hba.conf` replace the line.

```sh
host all all all scram-sha-256
```

with 

```sh
host all all all md5
```

and use `oc rsync` again to update the remote versions

```sh
oc rsync db/ <POD_NAME>:/var/lib/postgresql/data/pgdata/
```

Now redeploy the database use the `oc-process.sh` script.

```sh
./oc-process.sh -f template.yml -e .env -i deploy-db | oc replace -f -
```

To deploy a new database from a backup 