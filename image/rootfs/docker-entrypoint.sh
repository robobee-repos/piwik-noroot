#!/bin/bash
set -xe
 
function check_files_exists() {
  ls "$1" 1> /dev/null 2>&1
}

 function copy_file() {
   file="$1"; shift
  dir="$1"; shift
  mod="$1"; shift
   if [ -e "$file" ]; then
    mkdir -p "$dir"
    cp "$file" "$dir/$file"
    chmod $mod "$dir/$file"
   fi
 }
 
function copy_php_conf() {
  dir="/php-in"
  if [ ! -d "${dir}" ]; then
    return
  fi
  cd "${dir}"
  if ! check_files_exists "*.ini"; then
    return
  fi
  rsync -v "${dir}/*.ini" /usr/local/etc/php/conf.d/
 }
 
function copy_php_fpm_conf() {
  dir="/php-fpm-in"
  if [ ! -d "${dir}" ]; then
    return
  fi
  cd "${dir}"
  if ! check_files_exists "*.conf"; then
    return
  fi
  rsync -v "${dir}/*.conf" /usr/local/etc/php-fpm.d/
 }
 
 function sync_piwik() {
  if [ ! -e "$WEB_ROOT/piwik.php" ]; then
    return
  fi
   cd $WEB_ROOT
  rsync -rlD -u /usr/src/piwik/. .
 }
 
copy_php_conf
copy_php_fpm_conf
sync_piwik
 
cd "$WEB_ROOT"
echo "Running as `id`"
exec bash -x -- /entrypoint-old.sh "$@"
