FROM  piwik:3.2.0-fpm
LABEL maintainer "Erwin Mueller <erwin.mueller@deventm.com>"

ARG APT_CACHE
ENV WEB_ROOT /var/www/html
ENV WEB_USER www-data

RUN set -x \
  # Optional add proxy entries for apt.
  && if [ -n "${APT_CACHE}" ]; then \
  echo Acquire::ftp::Proxy \"$APT_CACHE\"; >> /etc/apt/apt.conf.d/08proxy;\
  echo Acquire::http::Proxy \"$APT_CACHE\"; >> /etc/apt/apt.conf.d/08proxy;\
  echo Acquire::https::Proxy \"$APT_CACHE\"; >> /etc/apt/apt.conf.d/08proxy;\
  fi \
  && DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y rsync \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && pecl install redis \
  && docker-php-ext-enable redis

# Web Root.

RUN set -x \
  && chown www-data $WEB_ROOT

# Php configuration.

ENV PHP_MAX_EXECUTION_TIME 300
ENV PHP_MEMORY_LIMIT_MB 128
ENV PHP_FPM_MAX_CHILDREN 10
ENV PHP_FPM_START_SERVERS 2
ENV PHP_FPM_MIN_SPARE_SERVERS 2
ENV PHP_FPM_MAX_SPARE_SERVERS 5
ENV PHP_FPM_MAX_REQUESTS 500
ENV PHP_FPM_REQUEST_SLOWLOG_TIMEOUT 30s
ENV PHP_FPM_CATCH_WORKERS_OUTPUT 1
ENV PHP_OPCACHE_ENABLE_CLI 1
ENV PHP_OPCACHE_ENABLE 1
ENV PHP_OPCACHE_MEMORY_CONSUMPTION_MB 128
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES 4000

RUN set -x \
  && ln -sf /dev/stdout /var/log/php-fpm-slow.log \
  && mkdir -p /php-in \
  && mkdir -p /php-fpm-in

ADD rootfs/opcache-recommended.ini /usr/local/etc/php/conf.d/zz-opcache-recommended.ini

ADD rootfs/conf.ini /usr/local/etc/php/conf.d/zz-conf.ini

ADD rootfs/www.conf /usr/local/etc/php-fpm.d/zz-www.conf

# Finishing up.

ADD rootfs/docker-entrypoint.sh /docker-entrypoint-in.sh
 
RUN set -x \
  && chmod +x /docker-entrypoint-in.sh \
  && mv /entrypoint.sh /entrypoint-old.sh \
  && mv /docker-entrypoint-in.sh /docker-entrypoint.sh \
  && mkdir -p /php-in \
  && chown www-data $WEB_ROOT

# Finishing up.

WORKDIR ${WEB_ROOT}
 
USER ${WEB_USER}

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]
