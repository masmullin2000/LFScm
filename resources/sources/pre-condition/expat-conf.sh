#!/bin/bash

set -e

mv expat ../expat-src
cd ..
rm -rf expat
mv expat-src expat
cd expat
./buildconf.sh