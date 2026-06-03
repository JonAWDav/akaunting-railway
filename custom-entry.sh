#!/bin/bash -e
# Populate the persistent volume from baked source on first boot (volume mounts over /var/www/html)
if [ ! -f /var/www/html/artisan ]; then
  echo "[custom-entry] empty volume -> populating /var/www/html from baked source"
  cp -a /opt/akaunting-src/. /var/www/html/
fi
cd /var/www/html
# Idempotent install: only run setup when not yet installed (no .env with an APP_KEY)
if [ -f .env ] && grep -q "APP_KEY=base64:" .env 2>/dev/null; then
  echo "[custom-entry] already installed -> serving without setup"
  unset AKAUNTING_SETUP
  exec /usr/local/bin/akaunting.sh --start
else
  echo "[custom-entry] fresh -> running one-time setup"
  export AKAUNTING_SETUP=true
  exec /usr/local/bin/akaunting.sh --setup
fi
