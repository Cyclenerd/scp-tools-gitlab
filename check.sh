#!/usr/bin/env bash

# Check SAP BTP SDK for the Neo environment

# GitHub Action runner
if [ -v GITHUB_RUN_ID ]; then
	echo "» Set git username and email"
	git config user.name "github-actions[bot]"
	git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
fi

# Check SAP Dev Tools website
curl "https://tools.hana.ondemand.com/" | grep -E -o -m 1 "neo-java-web-sdk-3[[:digit:]\.]+.zip" | sort -u > "/tmp/last-neo-sdk-version"

# echo "neo-java-web-sdk-1.2.3.zip" > "/tmp/last-neo-sdk-version"

# Check and replace version in Dockerfile
if grep "zip" < "/tmp/last-neo-sdk-version"; then
	export MY_NEO_SDK_VERSION=$(cat "/tmp/last-neo-sdk-version")
	echo "Neo SDK version : '$MY_NEO_SDK_VERSION'"
	perl -i -pe's|neo-java-web-sdk-[\d\.]+\.zip|$ENV{MY_NEO_SDK_VERSION}|' "Dockerfile"
else
	echo "ERROR: Neo SDK version not found!"
fi

if ! git diff --exit-code "Dockerfile"; then
	echo "SAP BTP SDK for the Neo environment changed!"
	git add "Dockerfile" || exit 9
	git commit -m "New Neo SDK version" || exit 9
	git push || exit 9
else
	echo "SAP BTP SDK for the Neo environment not changed."
fi

echo "DONE"