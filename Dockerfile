FROM ubuntu:latest

# Download URLs
ENV NEO_SDK_URL      "https://tools.hana.ondemand.com/sdk/neo-java-web-sdk-3.93.5.zip"
ENV MTA_BUILDER_URL  "https://tools.hana.ondemand.com/additional/mta_archive_builder-1.1.20.jar"
ENV NODEJS_URL       "https://deb.nodesource.com/setup_12.x"

# Storage locations
ENV NEO_SDK_HOME     "/opt/neo-sdk"
ENV MTA_BUILDER_HOME "/opt/mta-builder"

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

RUN set -eux; \
# Install base packages
	apt-get update -yqq; \
	apt-get install -yqq apt-utils wget ca-certificates git zip unzip tar lsb-release gnupg gettext-base; \
# Create storage locations
	mkdir -p "$NEO_SDK_HOME"; \
	mkdir -p "$MTA_BUILDER_HOME"; \
# Install Node.js
	wget -nv --output-document="$HOME/nodejs_setup.sh" "$NODEJS_URL"; \
	bash "$HOME/nodejs_setup.sh"; \
	apt-get update -yqq; \
	apt-get install -yqq nodejs; \
	rm "$HOME/nodejs_setup.sh"; \
# Install Node.js packages (https://www.npmjs.com/package)
	npm install grunt-cli -g; \
	npm install gulp-cli -g; \
	npm install showdown -g; \
	npm install eslint -g; \
	npm install eslint-plugin-ui5 -g; \
	npm install eslint-config-ui5 -g; \
	npm install ui5-toolkit-gulp -g; \
# Install SapMachine JDK
	wget -q -O - https://dist.sapmachine.io/debian/sapmachine.key | apt-key add -; \
	echo "deb http://dist.sapmachine.io/debian/amd64/ ./" | tee /etc/apt/sources.list.d/sapmachine.list; \
	apt-get update -yqq; \
	apt-get install -yqq sapmachine-11-jdk; \
# Install Cloud Foundry CLI
	wget -q -O - "https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key" | apt-key add -; \
	echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list; \
	apt-get update -yqq; \
	apt-get install -yqq cf-cli;\
# Install SAP Cloud Platform Neo Environment SDK (https://tools.hana.ondemand.com/#cloud)
	wget -nv --output-document="$HOME/neo-java-web-sdk.zip" --no-cookies --header "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt" "$NEO_SDK_URL"; \
	unzip -q -o "$HOME/neo-java-web-sdk.zip" -d "$NEO_SDK_HOME"; \
	rm "$HOME/neo-java-web-sdk.zip"; \
# Install SAP Multi-Target Application Archive Builder
	wget -nv --output-document="$MTA_BUILDER_HOME/mta_archive_builder.jar" --no-cookies --header "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt" "$MTA_BUILDER_URL"; \
# Basic smoke test
	uname -a; \
	wget --version | head -1; \
	zip -v | head -2; \
	unzip -v | head -1; \
	tar --version | head -1; \
	envsubst --version | head -1; \
	node --version; \
	npm --version; \
	java --version; \
	cf --version; \
	neo.sh version; \
	java -jar $MTA_BUILDER_HOME/mta_archive_builder.jar --version; \
# Delete apt cache
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!
#
#   https://github.com/Cyclenerd/scp-tools-gitlab/issues
