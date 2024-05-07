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

ENV SKIP_DEMO_DATA true
ENV ROOT_WEBAPP_REDIRECT true
ENV INSTALL_EXTENSIONS true
ENV STABLE_EXTENSIONS "vectortiles,wps,printing,control-flow,pyramid,monitor,inspire,csw"
ENV EXTRA_JAVA_OPTS "-Xms256m -Xmx1g -DENTITY_RESOLUTION_ALLOWLIST=*"

RUN /opt/install-extensions.sh \
 && echo "" > /opt/install-extensions.sh

RUN chgrp -R 0 /var/run /opt \
 && chmod -R g=u /var/run /opt /etc/passwd \
 && chmod gu+rw /var/run

ENTRYPOINT ["entrypoint.sh"]

CMD ["/opt/startup.sh"]
