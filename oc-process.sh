#!/bin/bash

i="all"

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

  HOST=$DEV_HOST
  DB_PASSWORD=$DEV_DB_PASSWORD
  GEOSERVER_DB_PASSWORD=$DEV_GEOSERVER_DB_PASSWORD

fi

if [ $i = "volume-app" ]; then

  ITEM=".items[0]"

elif [ $i = "volume-db" ]; then

  ITEM=".items[1]"

elif [ $i = "image" ]; then

  ITEM=".items[2]"

elif [ $i = "build" ]; then

  ITEM=".items[3]"  

elif [ $i = "config" ]; then

  ITEM=".items[4]"

elif [ $i = "secrets" ]; then

  ITEM=".items[5]"

elif [ $i = "deploy-app" ]; then

  ITEM=".items[6]"

elif [ $i = "deploy-db" ]; then

  ITEM=".items[7]"

elif [ $i = "service-app" ]; then

  ITEM=".items[8]"

elif [ $i = "service-db" ]; then

  ITEM=".items[9]"

elif [ $i = "route" ]; then

  ITEM=".items[10]"

else

  ITEM=""

fi

DB_USER=$(echo -n $DB_USER | base64)
DB_PASSWORD=$(echo -n $DB_PASSWORD | base64)
RCLONE_ACCESS_KEY_ID=$(echo -n $RCLONE_ACCESS_KEY_ID | base64)
RCLONE_SECRET_ACCESS_KEY=$(echo -n $RCLONE_SECRET_ACCESS_KEY | base64)

oc process -f $f \
  -p BRANCH="$BRANCH" \
  -p HOST="$HOST" \
  -p DB_PASSWORD="$DB_PASSWORD" \
  -p OBJECT_STORE="$OBJECT_STORE" \
  -p RCLONE_ACCESS_KEY_ID="$RCLONE_ACCESS_KEY_ID" \
  -p RCLONE_SECRET_ACCESS_KEY="$RCLONE_SECRET_ACCESS_KEY" \
  | jq $ITEM
