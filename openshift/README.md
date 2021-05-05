# Deploy to openshift

prerequisites:
1. You need oc command in path
2. You need to log in to Kontit with the oc command
3. Fill in the secrets

Run the following:
```shell
oc apply -f secrets.yaml
oc apply -f config-map.yaml
oc apply -f db-service.yaml
oc apply -f db-imagestream.yaml
oc apply -f db-deployment-config.yaml

oc rsync postgis/ postgis-4-5kkpk:/recover
oc exec postgis-4-5kkpk -- psql -d gis -h 127.0.0.1 -U docker -1 -f /recover/gis.sql
oc rsync ./geoserver-data geoserver-40-5qxxf:/
```