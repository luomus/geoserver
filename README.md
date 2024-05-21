# FinBIF Geoserver

## Deployment

The instance is designed to be deployed to OpenShift v4

An `.env` file should contain appropriate values for the following variables:

```sh
HOST=        # Domain name app will be hosted at
DEV_HOST=    # Domain name dev version of app will be hosted at
DB_PASSWORD=
DEV_DB_PASSWORD=
RCLONE_ACCESS_KEY_ID= # If a key and secret have not been created see here for instructions https://docs.csc.fi/support/faq/how-to-get-Allas-s3-credentials/
RCLONE_SECRET_ACCESS_KEY= 
OBJECT_STORE= # An existing object store container name found at the location specified in `rclone.conf` 
```

Use the script `oc-process.sh` to generate the project's objects and pipe them to the OpenShift command line tool `oc`.

For example:

```sh
oc login ... # copy token from OpenShift web UI
./oc-process.sh -f template.yml -e .env -i ~OBJECT_NAME~ | oc create -f - # Check oc-proces.sh for object names
```

### Setup database 

A new PostGIS database instance will require adjustments to the files `postgresql.conf` and `pg_hba.conf`.

First use `oc rsync` to make local copies of the two files.

```sh
mkdir tmp
oc login ...
oc get pods # Get name of PostGIS pod and replace in next line
oc rsync --exclude="*" --include="pg_hba.conf" --include="postgresql.conf" ~POD_NAME~:/var/lib/postgresql/data/pgdata/ tmp/
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
oc rsync tmp/ ~POD_NAME~:/var/lib/postgresql/data/pgdata/
```

Now redeploy the database

```sh
oc rollout restart deployment postgis-"$(git symbolic-ref --short -q HEAD)"
```

To deploy a new database from a SQL dump use `oc rsync` to upload the data.

```sh
oc get pods # Get name of new pod and replace in next line
oc rsync --exclude="*" --include="backup.sql.gz" tmp/ ~POD_NAME~:/tmp/
```

Open a terminal interface to the remote pod

```sh
oc exec ~POD_NAME~ -it -- bash
```

Create the database user

```sh
psql -U postgres -c "CREATE USER geoserver WITH PASSWORD '???????';" # use an appropriate password
```

Restore database from backup

```sh
psql -U postgres -d gis < /tmp/backup.sql # may need to run multiple times
exit
```

### Setup Geoserver

Log in to the geoserver web UI using the default user (admin) and password (geoserver).

Change the default admin password.

Set digest password encoding by going to "User, Groups, Roles" -> "User Group Services" -> 
"default" -> "Passwords" -> "Password encryption" and selecting "Digest" from the dropdown menu.

If needed to set the logging level under Settings -> Global.

Open a terminal interface to the remote pod

```sh
oc get pods # Get name of new pod and replace in next line
oc exec ~POD_NAME~ -it -- bash
```

and remove the master password text file.

```sh
rm /opt/geoserver_data/security/masterpw.info
exit
```

Restore the geoserver from a previous backup

```sh
tar -xzvf tmp/backup.tar.gz -C tmp
oc rsync \
  --exclude="*" \
  --include="layouts/***" \
  --include="legendsamples/***" \
  --include="rasters/***" \
  --include="shapefiles/***" \
  --include="workspaces/***" \
  --include="wfs.xml" \
  --include="wms.xml" \
  --include="wps.xml" \
  --include="global.xml" \
  --include="controlflow.properties" \
  tmp/opt/geoserver_data/ \
  ~POD_NAME~:/opt/geoserver_data/
oc rollout restart deployment geoserver-"$(git symbolic-ref --short -q HEAD)"
```

## Backups

To backup data run backup script from within the running geoserver pod.

```sh
oc get pods
oc exec ~POD_NAME~
```
