#!/usr/bin/env bash
set -euo pipefail

: "${SEED:?SEED is required}"
: "${DIFFICULTY:?DIFFICULTY is required}"

variant=$((SEED % 1))
: "$DIFFICULTY"

site=/etc/nginx/sites-available/default

# Move the live listen port off 80. Leave comments and the unit state alone.
case "$variant" in
  0)
    sed -i -E \
      -e '/^[[:space:]]*#/b' \
      -e 's/listen[[:space:]]+\[::\]:80/listen [::]:8080/' \
      -e 's/listen[[:space:]]+80/listen 8080/' \
      "$site"
    systemctl reload nginx
    ;;
esac
