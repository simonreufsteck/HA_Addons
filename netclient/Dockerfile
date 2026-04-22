ARG BUILD_FROM
FROM gravitl/netclient:v0.30.0 AS source

FROM $BUILD_FROM
RUN apk add --no-cache jq wireguard-tools iptables ip6tables kmod

COPY --from=source /usr/bin/netclient /usr/local/bin/netclient

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
