FROM alpine:3.20

ARG NETCLIENT_VERSION="0.30.0"

RUN apk add --no-cache \
    bash \
    curl \
    jq \
    wireguard-tools \
    iptables \
    ip6tables \
    kmod \
    iproute2

RUN ARCH="$(uname -m)" && \
    case "$ARCH" in \
      x86_64)  NC_ARCH="amd64" ;; \
      aarch64) NC_ARCH="arm64" ;; \
      armv7l)  NC_ARCH="arm" ;; \
      *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac && \
    echo "Downloading netclient ${NETCLIENT_VERSION} for ${NC_ARCH}..." && \
    curl -fsSL \
      "https://github.com/gravitl/netclient/releases/download/v${NETCLIENT_VERSION}/netclient-linux-${NC_ARCH}" \
      -o /usr/local/bin/netclient && \
    chmod +x /usr/local/bin/netclient

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
