# Piwik

## Description

The image modifies the base image to run as non-privileged user `www-data`. Furthermore, it adds the option to have a input directory for configuration files that can be used with Kubernetes Config Map. In addition, it adds rsync to synchronize the Piwik source from `/usr/src/piwik` to `/var/www/html` the web root directory. That is necessary if the web root directory is mounted as a Kubernetes Persistent Volume.

## Environment Parameters

| Variable | Default | Description |
| ------------- | ------------- | ----- |
| PHP_MAX_EXECUTION_TIME  | 300 | max_execution_time |
| PHP_MEMORY_LIMIT | 128M | memory_limit |
| PHP_FPM_MAX_CHILDREN | 10 | pm.max_children |
| PHP_FPM_START_SERVERS | 2 | pm.start_servers |
| PHP_FPM_MIN_SPARE_SERVERS | 2 | pm.min_spare_servers |
| PHP_FPM_MAX_SPARE_SERVERS | 5 | pm.max_spare_servers |
| PHP_FPM_MAX_REQUESTS | 500 | pm.max_requests |
| PHP_FPM_REQUEST_SLOWLOG_TIMEOUT | 0 | request_slowlog_timeout |
| PHP_FPM_CATCH_WORKERS_OUTPUT | 1 | catch_workers_output |
| PHP_OPCACHE_ENABLE_CLI | 1 | opcache.enable_cli |
| PHP_OPCACHE_ENABLE | 1 | opcache.enable |
| PHP_OPCACHE_MEMORY_CONSUMPTION | 128 | opcache.memory_consumption |
| PHP_OPCACHE_MAX_ACCELERATED_FILES | 6000 | opcache.max_accelerated_files |

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
| /piwik-in/*.php | /var/www/html/config/ |

## Test

The docker-compose file `test.yaml` can be used to startup MySQL and the Piwik container. The installation can be then accessed from `localhost:8080`.

```
cd test
make test
```

## Optimize php-fpm

 ```
find /var/www/html -iname *.php|wc -l
 ```

## License

Piwik is licensed under the [GPL v3 or later](https://piwik.org/licences/) license.

This image is licensed under the [MIT](https://opensource.org/licenses/MIT) license.

Copyright 2017 Erwin Müller

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
