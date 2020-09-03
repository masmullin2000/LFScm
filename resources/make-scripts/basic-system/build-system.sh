#!/bin/bash

set -e

for (( i=$1; i<=$2; i++ ))
do
	echo -e "Building $i\n\n\n\n\n\n"
	cd /sources && /basic-system/$i.*.sh 2>&1 > /dev/null || exit
done

