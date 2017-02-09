# openhab image
#
# ------------------------------------------------------------------------------
#               NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
#                       PLEASE DO NOT EDIT IT DIRECTLY.
# ------------------------------------------------------------------------------
#

FROM openhab/openhab:2.1.0-snapshot-armhf
USER root
# Basic build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="EPL" \
    org.label-schema.name="openHAB" \
    org.label-schema.url="http://www.openhab.com/" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/smeat/openhab-docker-mod.git"

# Install basepackages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    iputils-ping \
    && apt-get clean \
&& rm -rf /var/lib/apt/lists/*
      

RUN		apt-get update && \
apt-get install --no-install-recommends -y \
git-core make gcc g++ \
sudo \
&& git clone git://git.drogon.net/wiringPi /wiringPi \
&& cd /wiringPi \
&& ./build \
&& git clone https://github.com/xkonni/raspberry-remote /remote \
&& cd /remote \
&& make send \
&& cp ./send /usr/local/bin/send \
&& cd / && rm -rf /remote /wiringPi \
&& apt-get purge -y --auto-remove git-core make gcc g++ \
&& echo "openhab ALL=(root) NOPASSWD: /usr/local/bin/send" >> /etc/sudoers \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

USER openhab
