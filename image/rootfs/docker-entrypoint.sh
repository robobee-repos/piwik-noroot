#!/bin/bash
set -e

# Do not copy config.ini.php if Piwik is not installed yet.
function copy_piwik_in() {
  if [[ ! -f "${WEB_ROOT}/config/config.ini.php" ]]; then
    files=(config.ini.php)
    copy_files "/piwik-in" "${WEB_ROOT}/config" "*.php" files[@]
  else
    copy_files "/piwik-in" "${WEB_ROOT}/config" "*.php"
  fi
}

source /docker-entrypoint-utils.sh
set_debug
echo "Running as `id`"

copy_files "/php-in" "/usr/local/etc/php/conf.d" "*.ini"
copy_files "/php-fpm-in" "/usr/local/etc/php-fpm.d" "*.conf"
copy_piwik_in

sync_dir /usr/src/piwik ${WEB_ROOT}

cd "${WEB_ROOT}"
exec ${BASH_CMD} -- /entrypoint-old.sh "$@"
