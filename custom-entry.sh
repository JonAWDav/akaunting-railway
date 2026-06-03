#!/bin/bash -e
# Populate the persistent volume from baked source on first boot
if [ ! -f /var/www/html/artisan ]; then
  echo "[custom-entry] empty volume -> populating /var/www/html"
  cp -a /opt/akaunting-src/. /var/www/html/
fi
cd /var/www/html
# Reliable install check: does the DB already have the <prefix>companies table?
INSTALLED=$(php -r '
mysqli_report(MYSQLI_REPORT_OFF);
$h=getenv("DB_HOST");$p=getenv("DB_PORT")?:"3306";$d=getenv("DB_NAME");$u=getenv("DB_USERNAME");$pw=getenv("DB_PASSWORD");$pre=getenv("DB_PREFIX");
$m=@new mysqli($h,$u,$pw,$d,(int)$p);
if($m->connect_errno){echo "err";exit;}
$r=@$m->query("SELECT 1 FROM `".$pre."companies` LIMIT 1");
echo $r?"yes":"no";
' 2>/dev/null)
echo "[custom-entry] DB installed check: $INSTALLED"
if [ "$INSTALLED" = "yes" ]; then
  unset AKAUNTING_SETUP
  exec /usr/local/bin/akaunting.sh --start
else
  export AKAUNTING_SETUP=true
  exec /usr/local/bin/akaunting.sh --setup
fi
