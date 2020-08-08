#!/bin/bash

tar xvf perl-5.30.1.tar.xz
cd perl-5.30.1

sh Configure -des -Dprefix=/tools -Dlibs=-lm -Uloclibpth -Ulocincpth

make -j$(nproc)

cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.30.1
cp -Rv lib/* /tools/lib/perl5/5.30.1

cd ..
rm -rf perl-5.30.1