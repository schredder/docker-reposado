FROM nginx:1.7
MAINTAINER Eric Schroeder "ess@eschro.com"
# Forked from https://github.com/MScottBlake/docker-reposado

ENV PATH /reposado/code:$PATH

EXPOSE 8088

RUN apt-get update \
  && apt-get install -y cron curl python \
  && apt-get clean \
  && mkdir -p /reposado/code /reposado/html /reposado/metadata \
  && curl -ksSL https://github.com/wdas/reposado/tarball/master | tar zx \
  && cp -rf wdas-reposado-*/code/* /reposado/code/ \
  && rm -f master /etc/nginx/sites-enabled/default /etc/service/nginx/down \
  && rm -rf wdas-reposado-* /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY nginx.conf /etc/nginx/
COPY preferences.plist /reposado/code/
COPY reposado.conf /etc/nginx/sites-enabled/
COPY repo_sync.cron /etc/cron.d/repo_sync
COPY start.sh /reposado/code/

CMD ["/reposado/code/start.sh"]

RUN chown -R www-data:www-data /reposado \
  && chmod -R ug+rws /reposado

VOLUME /reposado/html
VOLUME /reposado/metadata
