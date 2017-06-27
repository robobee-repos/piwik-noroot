FROM  piwik:3.0.4-fpm
LABEL maintainer "Erwin Mueller <erwin.mueller@deventm.com>"

ARG APT_CACHE
ENV WEB_ROOT /var/www/html
ENV WEB_USER www-data
ENV PHP_MAX_EXECUTION_TIME 300
ENV PHP_MEMORY_LIMIT_MB 128
ENV PHP_FPM_MAX_CHILDREN 5
ENV PHP_FPM_START_SERVERS 2
ENV PHP_FPM_MIN_SPARE_SERVERS 1
ENV PHP_FPM_MAX_SPARE_SERVERS 3
ENV PHP_OPCACHE_ENABLE_CLI 0
ENV PHP_OPCACHE_ENABLE 1
ENV PHP_OPCACHE_MEMORY_CONSUMPTION_MB 128
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES 4000

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

# Php configuration.

RUN set -x \
  && mkdir -p /php-in \
  && mkdir -p /php-fpm-in

ADD rootfs/www.conf /usr/local/etc/php-fpm.d/zz-www.conf

ADD rootfs/opcache-recommended.ini /usr/local/etc/php/conf.d/zz-opcache-recommended.ini

ADD rootfs/conf.ini /usr/local/etc/php/conf.d/zz-conf.ini

# Web Root.

RUN set -x \
  && chown www-data $WEB_ROOT

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
