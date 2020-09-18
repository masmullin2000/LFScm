#!/bin/bash

NAME=lfs-build

if [[ $1 == "rebuild" ]]; then
	shift
	podman build -t $NAME .
fi
if [[ $1 == "man" ]]
then
	shift

	if [[ -n $1 ]]; then
		CPU=$1
	else
		CPU=$(nproc)
	fi
	podman run --rm --privileged --cpus $CPU -v /dev:/dev -v $PWD/output/:/output/ -v $PWD/input/:/input -it $NAME bash
else
	if [[ -n $3 ]]; then
		CPU=$3
	else
		CPU=$(nproc)
	fi
	podman run --rm --privileged --cpus $CPU -v /dev:/dev -v $PWD/output/:/output/ -v $PWD/input/:/input -it $NAME ./makeit.sh $1 $2
fi
