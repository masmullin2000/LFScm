#!/bin/bash

docker build -t build-lfs .
if [[ $1 == "man" ]]
then
	shift

	if [[ -n $1 ]]; then
		CPU=$1
	else
		CPU=$(nproc)
	fi
	docker run --rm --privileged --cpus $CPU -v /dev:/dev -v $PWD/output/:/output/ -v $PWD/input/:/input -it build-lfs bash
else
	if [[ -n $3 ]]; then
		CPU=$3
	else
		CPU=$(nproc)
	fi
	docker run --rm --privileged --cpus $CPU -v /dev:/dev -v $PWD/output/:/output/ -v $PWD/input/:/input -it build-lfs ./makeit.sh $1 $2
fi
