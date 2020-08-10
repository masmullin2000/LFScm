#!/bin/bash

set -e

a=$1
b=$2


for (( i=$1; i<=$2; i++ ))
do
	cd /sources && /basic-system/$i.*.sh || exit
done

#exec /bin/bash --login +h -c "/basic-system/system-2.sh"
