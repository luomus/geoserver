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

  DB_PASSWORD=$DEV_DB_PASSWORD

fi

if [ $i = "volume-app" ]; then

  ITEM=".items[0]"

elif [ $i = "volume-db" ]; then

  ITEM=".items[1]"

elif [ $i = "secrets" ]; then

  ITEM=".items[2]"

elif [ $i = "deploy-app" ]; then

  ITEM=".items[3]"

elif [ $i = "deploy-db" ]; then

  ITEM=".items[4]"

elif [ $i = "service-app" ]; then

  ITEM=".items[5]"

elif [ $i = "service-db" ]; then

  ITEM=".items[6]"

elif [ $i = "route" ]; then

  ITEM=".items[7]"

else

  ITEM=""

fi

DB_USER=$(echo -n $DB_USER | base64)
DB_PASSWORD=$(echo -n $DB_PASSWORD | base64)

oc process -f $f \
  -p BRANCH="$BRANCH" \
  -p DB_USER="$DB_USER" \
  -p DB_PASSWORD="$DB_PASSWORD" \
  | jq $ITEM
