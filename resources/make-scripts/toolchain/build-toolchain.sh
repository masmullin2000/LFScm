#!/bin/bash

source ~/.bashrc
set -e

for i in {1..32}
do
	cd "$LFS"/sources && /build/make-scripts/toolchain/$i.*.sh || exit
done

cd "$LFS"/sources && /build/make-scripts/toolchain/99.*.sh || exit
cd "$LFS"/tools && tar czvf /output/tools.tar.gz .
