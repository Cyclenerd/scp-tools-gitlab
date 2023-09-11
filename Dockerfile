FROM ubuntu:22.04

# Versions
ENV NODE_VERSION       "18"
ENV SAPMACHINE_VERSION "11"
ENV NEO_SDK_VERSION    "4.59.9.1"

# Download URLs
ENV NEO_SDK_URL        "https://tools.hana.ondemand.com/sdk/neo-java-web-sdk-$NEO_SDK_VERSION.zip"
ENV NODEJS_URL         "https://deb.nodesource.com/setup_16.x"
# Storage locations
ENV NEO_SDK_HOME       "/opt/neo-sdk"
ENV MTA_BUILDER_HOME   "/opt/mta-builder"

ENV JAVA_HOME "/usr/lib/jvm/sapmachine-11"
ENV PATH="${JAVA_HOME}/bin:${NEO_SDK_HOME}/tools:${PATH}"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Set debconf frontend to noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Disable warning: apt-key output should not be parsed (stdout is not a terminal)
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE true
# Disable error: Failed to download Chromium r650583
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Labels
LABEL org.opencontainers.image.title         "SAP Cloud Platform (SAP BTP) Tools optimized for GitLab Runner"
LABEL org.opencontainers.image.description   "The following software and tools are included: java, python3, cf, neo.sh, mbt, node, mkdocs"
LABEL org.opencontainers.image.url           "https://hub.docker.com/r/cyclenerd/scp-tools-gitlab"
LABEL org.opencontainers.image.authors       "https://github.com/Cyclenerd/scp-tools-gitlab/graphs/contributors"
LABEL org.opencontainers.image.documentation "https://github.com/Cyclenerd/scp-tools-gitlab/blob/master/README.md"
LABEL org.opencontainers.image.source        "https://github.com/Cyclenerd/scp-tools-gitlab"

RUN set -eux && \
# Install base packages
	apt-get update -yq && \
	apt-get install -yq apt-utils build-essential wget ca-certificates git zip unzip tar lsb-release gnupg gettext-base python3-pip && \
# Create storage locations
	mkdir -p "$NEO_SDK_HOME" && \
	mkdir -p "$MTA_BUILDER_HOME" && \
# Install Node.js \
    wget -q -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_${NODE_VERSION?}.x nodistro main" > /etc/apt/sources.list.d/nodesource.list && \
	apt-get update -yq && \
	apt-get install -yq nodejs && \
# Install Node.js packages (https://www.npmjs.com/package)
	npm install @ui5/cli -g && \
	npm install grunt-cli -g && \
	npm install gulp-cli -g && \
	npm install showdown -g && \
	npm install eslint -g && \
	npm install eslint-plugin-ui5 -g && \
	npm install eslint-config-ui5 -g && \
# Install SapMachine JDK
    wget -q -O - https://dist.sapmachine.io/debian/sapmachine.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/sapmachine.gpg && \
	echo "deb [signed-by=/etc/apt/trusted.gpg.d/sapmachine.gpg] http://dist.sapmachine.io/debian/amd64/ ./" > /etc/apt/sources.list.d/sapmachine.list && \
	apt-get update -yq && \
	apt-get install -yq "sapmachine-${SAPMACHINE_VERSION?}-jdk" && \
# Install Cloud Foundry CLI
    wget -q -O - "https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key" | gpg --dearmor -o /etc/apt/trusted.gpg.d/cloudfoundry.gpg && \
	echo "deb [signed-by=/etc/apt/trusted.gpg.d/cloudfoundry.gpg] https://packages.cloudfoundry.org/debian stable main" > /etc/apt/sources.list.d/cloudfoundry-cli.list && \
	apt-get update -yq && \
	apt-get install -yq cf-cli && \
# ...so that "cf deploy" is available
	cf install-plugin multiapps -f && \
# Install SAP Cloud Platform Neo Environment SDK (https://tools.hana.ondemand.com/#cloud)
	wget -nv --output-document="$HOME/neo-java-web-sdk.zip" --no-cookies --header "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt" "$NEO_SDK_URL" && \
	unzip -q -o "$HOME/neo-java-web-sdk.zip" -d "$NEO_SDK_HOME" && \
	rm "$HOME/neo-java-web-sdk.zip" && \
# Install mbt / Currently there is a bug in binwrap, so we have to use this workaround ( https://github.com/avh4/binwrap/issues/21 ) 
	npm install mbt -g --ignore-scripts && \
	cd /usr/lib/node_modules/mbt/ && \
	chmod -R 777 . && \
	npm install && \
# MkDocs
	pip3 install mkdocs  && \
	pip3 install mkdocs-material && \
	pip3 install mkdocs-minify-plugin && \
# Basic smoke test
	lsb_release -a && \
	uname -a && \
	wget --version | head -1 && \
	zip -v | head -2 && \
	unzip -v | head -1 && \
	tar --version | head -1 && \
	envsubst --version | head -1 && \
	node --version && \
	npm --version && \
	java --version && \
	python3 --version && \
	cf --version && \
	neo.sh version && \
	mbt --version && \
	mkdocs --version && \
# Delete cache
	pip3 cache purge && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!
#
#   https://github.com/Cyclenerd/scp-tools-gitlab/issues
