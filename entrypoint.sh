#!/bin/bash

echo "user:x:$(id -u):0::/opt:/sbin/nologin" >> /etc/passwd

"$@"
