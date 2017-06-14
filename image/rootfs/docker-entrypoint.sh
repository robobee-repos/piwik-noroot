#!/bin/bash
set -xe

function copy_file() {
  file="$1"; shift
  dir="$2"; shift
  if [ -e "$file" ]; then
    cp "$file" $dir/"$file"
    chmod 0644 $dir/"$file"
  fi
}

function copy_php() {
  cd /php-in
  copy_file php.ini /usr/local/etc/php/
}

function sync_piwik() {
  cd $WEB_ROOT
  rsync -v -rlD /usr/src/piwik/. .
}

if [ -d /php-in ]; then
  copy_php
fi

if [ -e "$WEB_ROOT/piwik.php" ]; then
  sync_piwik
fi

cd "$WEB_ROOT"
echo "Running as `id`"
exec bash -x -- /entrypoint-old.sh "$@"