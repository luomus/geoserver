#!/bin/bash

TIMESTAMP=$(date '+%Y%m%d%H%M%S')

echo "Archiving Geoserver data [$TIMESTAMP]"

tar -czvf backup-$TIMESTAMP-$BRANCH.tar.gz /opt/geoserver_data

echo "Copying data to object store [$TIMESTAMP]"

rclone copy "/opt/backup-$TIMESTAMP-$BRANCH.tar.gz" "default:$OBJECT_STORE"

echo "Removing local archive [$TIMESTAMP]"

rm /opt/backup-$TIMESTAMP-$BRANCH.tar.gz

echo "Create DB backup [$TIMESTAMP]"

PGPASSWORD=$POSTGRES_PASSWORD pg_dump -v -c postgresql://$POSTGRES_USER@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB > /tmp/backup-$TIMESTAMP-$BRANCH.sql

gzip /tmp/backup-$TIMESTAMP-$BRANCH.sql

echo "Copying data to object store [$TIMESTAMP]"

rclone copy "/tmp/backup-$TIMESTAMP-$BRANCH.sql.gz" "default:$OBJECT_STORE"

echo "Removing local archive [$TIMESTAMP]"

rm /tmp/backup-$TIMESTAMP-$BRANCH.sql.gz
