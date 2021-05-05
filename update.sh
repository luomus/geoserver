#!/bin/bash
set -e

OC_USER="$( oc whoami )"

if [[ -z "${OC_USER}" ]]; then
  echo ""
  echo "Please login with oc command first!!!"
  echo ""
  exit 1
fi

POD_GEO="$( oc get pods --no-headers=true -o custom-columns=NAME:.metadata.name --selector='app=geoserver' )"
POD_POSTGIS="$( oc get pods --no-headers=true -o custom-columns=NAME:.metadata.name --selector='deployment=postgis-4' )"

echo "Geoserver POD:"
echo "$POD_GEO"
echo ""
echo "Postgis POD:"
echo "$POD_POSTGIS"
echo ""
echo "continuing in 10sec"

sleep 10


echo "Copying sql to recover"
oc rsync --no-perms=true --delete=true postgis/ "${POD_POSTGIS}:/recover"

echo "Running sql dump to db"
oc exec "${POD_POSTGIS}" -- psql -d gis -h 127.0.0.1 -U docker -q -1 -f /recover/gis.sql

echo "Sync geoserver-data with geoserver"
oc rsync --no-perms=true --delete=true ./geoserver-data "${POD_GEO}:/"

echo ""
echo "All done"
echo ""