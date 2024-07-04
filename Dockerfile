# docker manifest inspect docker.osgeo.org/geoserver:2.25.2 -v | jq '.Descriptor.digest'
FROM docker.osgeo.org/geoserver:2.25.2@sha256:08a08222093d5575282a02f4182ce2519fe6fad9ad7b0b4c2a293ef43793d5bc

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY backup.sh /usr/local/bin/backup.sh
COPY rclone.conf /opt/.config/rclone/rclone.conf

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      gpg \
      rclone \
      rsync \
 && apt-get autoremove --purge -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/*

RUN wget --quiet -O - https://www.PostgreSQL.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg \
 && echo "deb http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      postgresql-client-16 \
 && apt-get autoremove --purge -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/*

ENV SKIP_DEMO_DATA true
ENV ROOT_WEBAPP_REDIRECT true
ENV INSTALL_EXTENSIONS true
ENV STABLE_EXTENSIONS "vectortiles,wps,printing,control-flow,pyramid,monitor,inspire,csw"

RUN /opt/install-extensions.sh \
 && echo "" > /opt/install-extensions.sh

RUN chgrp -R 0 /var/run /opt \
 && chmod -R g=u /var/run /opt /etc/passwd \
 && chmod gu+rw /var/run

ENTRYPOINT ["entrypoint.sh"]

CMD ["/opt/startup.sh"]
