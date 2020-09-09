#!/bin/bash

set -e

autoreconf -i

cat >doc/version.texi <<EOF
@set UPDATED 19 January 2038
@set UPDATED-MONTH January 2038
@set EDITION 12.35
@set VERSION 12.35
EOF