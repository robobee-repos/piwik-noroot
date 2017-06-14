FROM  piwik:3.0.4-fpm
LABEL maintainer "Erwin Mueller <erwin.mueller@deventm.com>"

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
