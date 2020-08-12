#!/bin/bash

docker build -t build-lfs .
docker run --rm --privileged -v /dev:/dev -v $PWD/../storage/:/output/ -v $PWD/../storage/:/input -it build-lfs ./makeit.sh $1