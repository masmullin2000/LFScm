#!/bin/bash

set -e

git config user.email "build-maker@example.com"
git config user.name "Build Maker"

echo "3.7.69" > .version
echo "3.7.69" > .tarball-version
git submodule update --init
./bootstrap --copy --gnulib-srcdir=../gnulib
./configure
git clean -fd .
git status

set +e
make release-commit RELEASE='3.7.69 alpha'
set -e
rm -rf .git
make dist-xz
mv bison*.tar.xz ..
cd ..
rm -rf bison
tar xf bison*.tar.xz
rm -f bison*.tar.xz
mv bison* bison
