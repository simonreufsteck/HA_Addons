FROM gravitl/netclient:v0.30.0

# Installiere bashio für HA-Konfigurationszugriff
RUN apk add --no-cache bash curl jq

# bashio herunterladen (HA Shell-Helper-Bibliothek)
ARG BASHIO_VERSION="0.16.2"
RUN curl -Lso /tmp/bashio.tar.gz \
      "https://github.com/hassio-addons/bashio/archive/v${BASHIO_VERSION}.tar.gz" \
    && mkdir -p /usr/src/bashio \
    && tar xzf /tmp/bashio.tar.gz --strip 1 -C /usr/src/bashio \
    && mv /usr/src/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    && rm -rf /tmp/bashio.tar.gz /usr/src/bashio

# Startskript kopieren
COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
