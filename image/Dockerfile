FROM  piwik:3.0.4-fpm
LABEL maintainer "Erwin Mueller <erwin.mueller@deventm.com>"

RUN set -x \
  && DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y rsync \
  && rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Install docker-entrypoint.sh

ADD rootfs/docker-entrypoint.sh /docker-entrypoint-in.sh

ENV WEB_ROOT /var/www/html

RUN set -x \
  && chmod +x /docker-entrypoint-in.sh \
  && mv /entrypoint.sh /entrypoint-old.sh \
  && mv /docker-entrypoint-in.sh /docker-entrypoint.sh \
  && mkdir -p /php-in \
  && chown www-data $WEB_ROOT

# Finishing up.

WORKDIR $WEB_ROOT

USER www-data

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm"]
