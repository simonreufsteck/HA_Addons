#!/usr/bin/env bash
set -e

# =============================================================================
# Netmaker Netclient – Home Assistant Add-on Startskript
# =============================================================================

CONFIG_PATH=/data/options.json

# --- Pflichtfeld: Token ---
TOKEN=$(jq -r '.token' "$CONFIG_PATH")
if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
  echo "[ERROR] Kein Netmaker-Token konfiguriert. Bitte in den Add-on-Einstellungen eintragen."
  exit 1
fi
export TOKEN

# --- Optionale Felder ---
HOSTNAME=$(jq -r '.hostname // empty' "$CONFIG_PATH")
ENDPOINT=$(jq -r '.endpoint // empty' "$CONFIG_PATH")
PORT=$(jq -r '.port // 0' "$CONFIG_PATH")
MTU=$(jq -r '.mtu // 0' "$CONFIG_PATH")
IS_STATIC=$(jq -r '.is_static // false' "$CONFIG_PATH")
VERBOSITY=$(jq -r '.verbosity // 0' "$CONFIG_PATH")

[ -n "$HOSTNAME" ]              && export HOST_NAME="$HOSTNAME"
[ -n "$ENDPOINT" ]              && export ENDPOINT
[ "$PORT" -gt 0 ] 2>/dev/null   && export PORT
[ "$MTU" -gt 0 ] 2>/dev/null    && export MTU
[ "$IS_STATIC" = "true" ]       && export IS_STATIC="true"

# --- Persistente Daten ---
# /config wird vom HA Supervisor als persistenter Speicher gemountet (config:rw)
mkdir -p /config/netclient
ln -sfn /config/netclient /etc/netclient

echo "========================================"
echo " Netmaker Netclient Add-on"
echo "========================================"
echo " Hostname:   ${HOST_NAME:-$(hostname)}"
echo " Endpoint:   ${ENDPOINT:-(auto)}"
echo " Port:       ${PORT:-auto}"
echo " MTU:        ${MTU:-auto}"
echo " Static:     ${IS_STATIC:-false}"
echo " Verbosity:  ${VERBOSITY}"
echo "========================================"

# --- Netclient im Daemon-Modus starten ---
echo "[INFO] Starte netclient daemon..."
exec netclient daemon -v "$VERBOSITY"
