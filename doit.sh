#!/bin/bash

docker build -t build-lfs .
if [[ $1 == "man" ]]
then
	shift
	docker run --rm --privileged -v /dev:/dev -v $PWD/output/:/output/ -v $PWD/input/:/input -it build-lfs bash
else
	docker run --rm --privileged -v /dev:/dev -v $PWD/output/:/output/ -v $PWD/input/:/input -it build-lfs ./makeit.sh $1 $2
fi
