#!/bin/bash

TIMESTAMP=$(date '+%Y%m%d%H%M%S')

echo "Archiving Geoserver data [$TIMESTAMP]\n"

tar -czvf backup-$TIMESTAMP-$BRANCH.tar.gz /opt/geoserver_data

echo "Copying data to object store [$TIMESTAMP]\n"

rclone copy "/opt/backup-$TIMESTAMP-$BRANCH.tar.gz" "default:$OBJECT_STORE"

echo "Removing local archive [$TIMESTAMP]\n"

rm /opt/backup-$TIMESTAMP-$BRANCH.tar.gz
