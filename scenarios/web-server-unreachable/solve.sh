#!/usr/bin/env bash
set -euo pipefail

site=/etc/nginx/sites-available/default

sed -i -E \
  -e '/^[[:space:]]*#/b' \
  -e 's/listen[[:space:]]+\[::\]:8080/listen [::]:80/' \
  -e 's/listen[[:space:]]+8080/listen 80/' \
  "$site"

systemctl reload nginx
