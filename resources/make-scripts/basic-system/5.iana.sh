#!/bin/bash

set -e

tar xf iana.tar.gz
cd iana

cp services protocols /etc

cd ../
rm -rf iana