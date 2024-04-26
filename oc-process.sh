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

if [ $i = "volume" ]; then

ITEM=".items[0]"

elif [ $i = "deploy-db" ]; then

ITEM=".items[1]"

else

  ITEM=""

fi

oc process -f $f \
-p BRANCH=$BRANCH \
-p DB_PORT=$DB_PORT \
-p DB_USER=$DB_USER \
-p DB_PASSWORD=$DB_PASSWORD \
| jq $ITEM
