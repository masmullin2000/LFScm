#!/bin/bash

set -e

git config user.email "build-maker@example.com"
git config user.name "Build Maker"

if [[ -f "/build/sources/patches/systemd.patch" ]]; then
	git am < /build/sources/patches/systemd.patch
fi