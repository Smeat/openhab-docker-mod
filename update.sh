#!/bin/bash
set -eo pipefail

# Dockerfiles to be generated
versions="2.1.0-snapshot 2.0.0 1.8.3"
arches="amd64 armhf arm64"

# Generate header
print_header() {
	cat > $1 <<-EOI
	# openhab image
	#
	# ------------------------------------------------------------------------------
	#               NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
	#
	#                       PLEASE DO NOT EDIT IT DIRECTLY.
	# ------------------------------------------------------------------------------
	#

	EOI
}

# Print selected image
print_baseimage() {
	cat >> $1 <<-EOI
	FROM openhab/openhab:$version-$arch
	USER root
	EOI
}

print_raspberry(){
	cat >> $1 <<-'EOI'

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

EOI
}

# Print metadata && basepackages
print_basepackages() {
	cat >> $1 <<-'EOI'
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
	    fontconfig \
	    && apt-get clean \
		&& rm -rf /var/lib/apt/lists/*

EOI
}

# Set working directory and execute command
print_command() {
	cat >> $1 <<-'EOI'
	USER openhab
EOI
}

# Build the Dockerfiles
for version in $versions
do
	for arch in $arches
	do
		file=$version/$arch/Dockerfile
			mkdir -p `dirname $file` 2>/dev/null
			echo -n "Writing $file..."
			print_header $file;
			print_baseimage $file;
			print_basepackages $file;
			if [ "$arch" == "armhf" ]; then
				print_raspberry $file;
			fi
			print_command $file
			echo "done"
	done
done

