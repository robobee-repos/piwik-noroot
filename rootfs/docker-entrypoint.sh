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

if [ -d /php-in ]; then
  copy_php
fi

echo "Running as `id`"
cd $WEB_ROOT
exec bash -x -- /entrypoint-old.sh "$@"
