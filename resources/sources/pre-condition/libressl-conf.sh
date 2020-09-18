#!/bin/bash

set -e

git config user.email "build-maker@example.com"
git config user.name "Build Maker"

if [[ -f "/build/sources/patches/0001-x509_verify.h.patch" ]]; then
	git am < /build/sources/patches/0001-x509_verify.h.patch
fi

./autogen.sh

