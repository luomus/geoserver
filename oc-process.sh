#!/bin/bash

i="all"
f="template.yml"
e=".env"

while getopts ":f:e:i::" flag; do
  case $flag in
    f) f=${OPTARG} ;;
    e) e=${OPTARG} ;;
    i) i=${OPTARG} ;;
  esac
done

set -a

source ./$e

set +a

BRANCH=$(git symbolic-ref --short -q HEAD)

if [ "$BRANCH" != "main" ]; then

  HOST=$HOST_DEV
  DB_PASSWORD=$DB_PASSWORD_DEV
  GEOSERVER_DB_PASSWORD=$GEOSERVER_DB_PASSWORD_DEV
  EXTRA_JAVA_OPTS=$EXTRA_JAVA_OPTS_DEV
  MEMORY_APP=$MEMORY_APP_DEV
  MEMORY_DB=$MEMORY_DB_DEV

fi

if [ $i = "volume-app" ]; then

  ITEM=".items[0]"

elif [ $i = "volume-db" ]; then

  ITEM=".items[1]"

elif [ $i = "config" ]; then

  ITEM=".items[2]"

elif [ $i = "secrets" ]; then

  ITEM=".items[3]"

elif [ $i = "deploy-app" ]; then

  ITEM=".items[4]"

elif [ $i = "deploy-db" ]; then

  ITEM=".items[5]"

elif [ $i = "service-app" ]; then

  ITEM=".items[6]"

elif [ $i = "service-db" ]; then

  ITEM=".items[7]"

elif [ $i = "route" ]; then

  ITEM=".items[8]"

elif [ $i = "all" ]; then

  ITEM=""

else

  echo "Object not found"
  exit 1

fi

DB_PASSWORD=$(echo -n $DB_PASSWORD | base64)
RCLONE_ACCESS_KEY_ID=$(echo -n $RCLONE_ACCESS_KEY_ID | base64)
RCLONE_SECRET_ACCESS_KEY=$(echo -n $RCLONE_SECRET_ACCESS_KEY | base64)

echo "# $(oc project geoserver)"

oc process -f $f \
  -p BRANCH="$BRANCH" \
  -p HOST="$HOST" \
  -p DB_PASSWORD="$DB_PASSWORD" \
  -p EXTRA_JAVA_OPTS="$EXTRA_JAVA_OPTS" \
  -p MEMORY_APP="$MEMORY_APP" \
  -p MEMORY_DB="$MEMORY_DB" \
  -p OBJECT_STORE="$OBJECT_STORE" \
  -p RCLONE_ACCESS_KEY_ID="$RCLONE_ACCESS_KEY_ID" \
  -p RCLONE_SECRET_ACCESS_KEY="$RCLONE_SECRET_ACCESS_KEY" \
  | jq $ITEM
