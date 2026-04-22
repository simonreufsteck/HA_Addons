#!/usr/bin/env bash
set -e

CONFIG=/data/options.json

# Read required token
TOKEN=$(jq -r '.token // empty' "$CONFIG")
if [ -z "$TOKEN" ]; then
    echo "[ERROR] No enrollment token configured. Set the token in the add-on options."
    exit 1
fi

HOSTNAME=$(jq -r '.hostname // empty' "$CONFIG")
VERBOSITY=$(jq -r '.verbosity // 0' "$CONFIG")

# Use persistent config directory (mapped via config:rw)
mkdir -p /config/netclient
ln -sfn /config/netclient /etc/netclient

echo "========================================"
echo " Netmaker Netclient"
echo " Hostname : ${HOSTNAME:-$(hostname)}"
echo " Verbosity: ${VERBOSITY}"
echo "========================================"

# Load WireGuard kernel module
modprobe wireguard 2>/dev/null \
    && echo "[netclient] WireGuard module loaded." \
    || echo "[netclient] WireGuard built-in or unavailable, continuing..."

# Enable IP forwarding (required for WireGuard routing)
if [ "$(cat /proc/sys/net/ipv4/ip_forward 2>/dev/null)" = "1" ]; then
    echo "[netclient] IP forwarding already enabled."
else
    echo 1 > /proc/sys/net/ipv4/ip_forward 2>/dev/null \
        && echo "[netclient] IP forwarding enabled." \
        || echo "[netclient] WARNING: Could not enable IP forwarding."
fi

# Join only if not already registered
if [ ! -f /etc/netclient/netclient.yml ]; then
    echo "[netclient] Joining network..."

    JOIN_ARGS=(-t "$TOKEN")
    [ -n "$HOSTNAME" ] && JOIN_ARGS+=(-o "$HOSTNAME")

    netclient join "${JOIN_ARGS[@]}"
    echo "[netclient] Successfully joined."
else
    echo "[netclient] Already registered, skipping join."
fi

echo "[netclient] Starting daemon..."
exec netclient daemon -v "$VERBOSITY"
