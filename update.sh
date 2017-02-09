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

# Print metadata && basepackages
print_basepackages() {
	cat >> $1 <<-'EOI'  
	# Install basepackages
	RUN apt-get update && \
	    apt-get install --no-install-recommends -y \
	      iputils-ping \
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
			print_command $file
			echo "done"
	done
done

