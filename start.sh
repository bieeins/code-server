#!/usr/bin/env bash
set -e

echo "Launching VS Code Web (Alpine)..."

mkdir -p "$SERVER_DATA_DIR"

TOKEN_OPT=""

if [ -n "$CONNECTION_TOKEN" ]; then
  echo "Using connection token"
  TOKEN_OPT="--connection-token ${CONNECTION_TOKEN}"
else
  echo "WARNING: running WITHOUT connection token"
  TOKEN_OPT="--without-connection-token"
fi

exec code serve-web \
  --host "${HOST:-0.0.0.0}" \
  --port "${PORT:-8585}" \
  --server-data-dir "${SERVER_DATA_DIR}" \
  --accept-server-license-terms \
  --without-connection-token
  # ${TOKEN_OPT}
