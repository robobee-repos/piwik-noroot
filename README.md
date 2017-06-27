# Piwik-Noroot

## Description

The image modifies the base image to run as non-privileged user `www-data`.
Furthermore, it adds the option to have a input directory for configuration
files that can be used with Kubernetes Config Map. In addition, it adds
rsync to sync the Piwik source from `/usr/src/piwik` to `/var/www/html`
the web root directory. That is necessary if the web root directory is mounted
as a Kubernetes Persistent Volume and a newer image is deployed the source 
will not update the deployment.

## Environment Parameters

| Variable | Default | Description |
| ------------- | ------------- | ----- |
| PHP_MAX_EXECUTION_TIME  | 300 | max_execution_time |
| PHP_MEMORY_LIMIT_MB | 128 | memory_limit |
| PHP_FPM_MAX_CHILDREN | 5 | pm.max_children |
| PHP_FPM_START_SERVERS | 2 | pm.start_servers |
| PHP_FPM_MIN_SPARE_SERVERS | 1 | pm.min_spare_servers |
| PHP_FPM_MAX_SPARE_SERVERS | 3 | pm.max_spare_servers |
| PHP_OPCACHE_ENABLE_CLI | 1 | opcache.enable_cli |
| PHP_OPCACHE_ENABLE | 1 | opcache.enable |
| PHP_OPCACHE_MEMORY_CONSUMPTION_MB | 4000 | opcache.max_accelerated_files |

## Exposed Ports

| Port | Description |
| ------------- | ----- |
| 9000  | php-fpm |

## Directories

| Path | Description |
| ------------- | ----- |
| /var/www/html  | www-root directory. |

## Input Configration

| Source | Destination |
| ------------- | ------------- |
| /php-in/*.ini | /usr/local/etc/php/ |
| /php-fpm-in/*.conf | /usr/local/etc/php-fpm.d/ |

## Test

The docker-compose file `test.yaml` can be used to startup MySQL and the
Piwik container. The installation can be then accessed
from `localhost:8080`.

```
cd test
make up &
```
