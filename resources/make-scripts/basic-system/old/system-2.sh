#!/bin/bash

set -e

for i in {30..71}
do
	cd /sources && /basic-system/$i.*.sh
done

cd /sources && /basic-system/99.strip.sh

