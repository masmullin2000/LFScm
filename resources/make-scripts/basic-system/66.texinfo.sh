#!/bin/bash

set -e

tar xf texinfo.tar.gz
cd texinfo

./configure --prefix=/usr --disable-static

make -j$(nproc)

#make check -j$(nproc)

make install

make TEXMF=/usr/share/texmf install-tex

pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd

cd ../
rm -rf texinfo
