# docker manifest inspect docker.osgeo.org/geoserver:2.25.0 -v | jq '.Descriptor.digest'
FROM docker.osgeo.org/geoserver:2.25.0@sha256:19335fcc02fbdcbcff0acdc89a05831f88e074d9025e49b11cb0355df1091c4f

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      rclone \
      rsync \
 && apt-get autoremove --purge -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/*

RUN chgrp -R 0 /var/run /opt \
 && chmod -R g=u /var/run /opt /etc/passwd \
 && chmod gu+rw /var/run

ENTRYPOINT ["entrypoint.sh"]

CMD ["/opt/startup.sh"]
