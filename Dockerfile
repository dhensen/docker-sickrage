FROM alpine:edge
MAINTAINER tim@haak.co

# add sickrage user withouth shell access, system user, no password and no home dir with UID=1000
RUN adduser -s /sbin/nologin -S -D -H -u 1000 sickrage

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm'

RUN apk -U upgrade && \
    apk -U add \
        ca-certificates \
        py2-pip ca-certificates git python py-libxml2 py-lxml \
        make gcc g++ python-dev openssl-dev libffi-dev unrar \
        && \
    pip --no-cache-dir install --upgrade setuptools && \
    pip --no-cache-dir install --upgrade pyopenssl cheetah requirements && \
    git clone --depth 1 https://github.com/SickRage/SickRage.git /sickrage && \
    apk del make gcc g++ python-dev && \
    rm -rf /tmp && \
    rm -rf /var/cache/apk/*

# to enable sickrage updates via git give ownership to sickrage user
RUN chown -R sickrage:root /sickrage

ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh

VOLUME ["/config", "/data", "/cache"]

EXPOSE 8081

USER sickrage
CMD ["/start.sh"]
