ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache curl jq wireguard-tools iptables ip6tables kmod

ARG NETCLIENT_VERSION="0.30.0"
RUN ARCH=$(uname -m) && \
    case "$ARCH" in \
      x86_64)  NC_ARCH="amd64" ;; \
      aarch64) NC_ARCH="arm64" ;; \
      arm*)    NC_ARCH="arm" ;; \
      *) echo "Unsupported arch: $ARCH" && exit 1 ;; \
    esac && \
    curl -fsSL -o /usr/local/bin/netclient \
      "https://github.com/gravitl/netclient/releases/download/v${NETCLIENT_VERSION}/netclient-linux-${NC_ARCH}" && \
    chmod +x /usr/local/bin/netclient

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
