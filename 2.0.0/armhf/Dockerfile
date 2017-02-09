# openhab image
#
# ------------------------------------------------------------------------------
#               NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
#                       PLEASE DO NOT EDIT IT DIRECTLY.
# ------------------------------------------------------------------------------
#

FROM openhab/openhab:2.0.0-armhf
USER root
# Install basepackages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      iputils-ping \
      && rm -rf /var/lib/apt/lists/*

USER openhab
