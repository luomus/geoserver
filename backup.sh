#!/bin/bash

TIMESTAMP=$(date '+%Y%m%d%H%M%S')

echo "Archiving Geoserver data [$TIMESTAMP]"

tar -czvf backup-$TIMESTAMP-$BRANCH.tar.gz /opt/geoserver_data

echo "Copying data to object store [$TIMESTAMP]"

rclone copy "/opt/backup-$TIMESTAMP-$BRANCH.tar.gz" "default:$OBJECT_STORE"

echo "Removing local archive [$TIMESTAMP]"

rm /opt/backup-$TIMESTAMP-$BRANCH.tar.gz
