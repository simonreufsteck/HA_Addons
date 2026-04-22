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
