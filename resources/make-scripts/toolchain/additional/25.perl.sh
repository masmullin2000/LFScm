#!/bin/bash

set -e

tar xvf perl.tar.gz
cd perl

sh Configure -des                                     \
             -Dprefix=/usr                            \
             -Dvendorprefix=/usr                      \
             -Dprivlib=/usr/share/perl5/core_perl     \
             -Darchlib=/usr/lib/perl5/5.32/core_perl  \
             -Dsitelib=/usr/share/perl5/site_perl     \
             -Dsitearch=/usr/lib/perl5/5.32/site_perl \
             -Dvendorlib=/usr/share/perl5/vendor_perl \
             -Dvendorarch=/usr/lib/perl5/5.32/vendor_perl

make -j$(nproc)

make install

cd ..
rm -rf perl