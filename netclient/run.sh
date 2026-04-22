#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

TOKEN=$(jq -r '.token' "$CONFIG_PATH")
if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
  echo "[ERROR] Kein Netmaker-Token konfiguriert. Bitte in den Add-on-Einstellungen eintragen."
  exit 1
fi

HOSTNAME=$(jq -r '.hostname // empty' "$CONFIG_PATH")
ENDPOINT=$(jq -r '.endpoint // empty' "$CONFIG_PATH")
PORT=$(jq -r '.port // 0' "$CONFIG_PATH")
MTU=$(jq -r '.mtu // 0' "$CONFIG_PATH")
IS_STATIC=$(jq -r '.is_static // false' "$CONFIG_PATH")
VERBOSITY=$(jq -r '.verbosity // 0' "$CONFIG_PATH")

mkdir -p /config/netclient
ln -sfn /config/netclient /etc/netclient

# Only join if not already registered
if [ ! -f /etc/netclient/netclient.yml ]; then
  echo "[netclient] joining network"

  JOIN_ARGS=(-t "$TOKEN")
  [ -n "$HOSTNAME" ]            && JOIN_ARGS+=(-o "$HOSTNAME")
  [ -n "$ENDPOINT" ]            && JOIN_ARGS+=(-e "$ENDPOINT")
  [ "$PORT" -gt 0 ] 2>/dev/null && JOIN_ARGS+=(-p "$PORT")
  [ "$MTU"  -gt 0 ] 2>/dev/null && JOIN_ARGS+=(-m "$MTU")
  [ "$IS_STATIC" = "true" ]     && JOIN_ARGS+=(-i)

  netclient join "${JOIN_ARGS[@]}"
else
  echo "[netclient] already joined, skipping join"
fi

echo "[netclient] starting netclient daemon"
exec netclient daemon -v "$VERBOSITY"
