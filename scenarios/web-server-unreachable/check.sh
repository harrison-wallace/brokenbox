#!/usr/bin/env bash
set -u

fails=0

pass() { printf 'PASS: %s\n' "$1"; }
fail() { printf 'FAIL: %s\n' "$1"; fails=$((fails + 1)); }
info() { printf 'INFO: %s\n' "$1"; }

site=/etc/nginx/sites-enabled/default

if systemctl is-enabled nginx >/dev/null 2>&1; then
  pass "nginx.service is enabled"
else
  fail "nginx.service is enabled"
fi

if systemctl is-active nginx >/dev/null 2>&1; then
  pass "nginx.service is active"
else
  fail "nginx.service is active"
fi

if grep -Eq '^[[:space:]]*listen[[:space:]]+80\b' "$site"; then
  pass "/etc/nginx/sites-enabled/default listens on port 80"
else
  fail "/etc/nginx/sites-enabled/default listens on port 80"
fi

if ss -H -ltn 'sport = :80' | grep -q .; then
  pass "a process is listening on TCP port 80"
else
  fail "a process is listening on TCP port 80"
fi

ver=$(nginx -v 2>&1 | sed -n 's/.*nginx\///p')
if [ -n "$ver" ]; then
  info "detected nginx ${ver}"
fi

if [ "$fails" -eq 0 ]; then
  exit 0
fi
exit 1
