#!/bin/bash

NAME=lfs-build
CONTAINER="docker"
TYPE="lfs"
NEW_CONTAINER=0
CPU=`nproc`
SAVE_PROG="no"
MANUAL=0
JUST_FETCH=""
EXTRA=""

function usage {
	echo -e "doit:\n\t-t|--type (scm|lfs|dev): type of build\n\t\tbuild an scm (git based) lfs (10.0) or dev (current lfs development version)"
	echo -e "\t-n|--new_cont: new container\n\t\tRebuild the Dockerfile"
	echo -e "\t-c|--cpus: cpu limit\n\t\tlimit container to # of cpus"
	echo -e "\t-s|--save_prog: save progress\n\t\tSave the Progress in the output directory (useful for scm builds)"
	echo -e "\t-m|--manual: manual container\n\t\trun the container but do not run the makeit script"
	echo -e "\t-p|--podman:\n\t\tuse podman instead of docker"
	echo -e "\t-f|--fetch:\n\t\tJust fetch the code, do not compile anything"
	echo -e "\t-e|--extra:\n\t\tAdd Extras (wireguard ssh wget etc"
	echo -e "\n\n\tExample:\n\t\t$ sudo ./doit -t scm -n -c 4 -s -p"
	echo -e "\tmeaning:\n\t\tUse podman to run the SCM build with 4 cpus,\n\t\tensure that the Dockerfile has been run,\n\t\tsave progress into output dir as we build"
}

while [ ! -z "$1" ]
do
	case "$1" in
		-t|--type)
			TYPE=$2
			shift
			;;
		-n|--new_cont)
			NEW_CONTAINER=1
			;;
		-c|--cpus)
			CPU=$2
			shift
			;;
		-s|--save_prog)
			SAVE_PROG="yes"
			;;
		-m|--manual)
			MANUAL=1
			;;
		-h|--help)
			usage
			exit 0
			;;
		-p|--podman)
			CONTAINER="podman"
			if [[ $UID != 0 ]]; then
				echo -e "Permission Error: You must have root privileges to run this command with podman"
				exit 1
			fi
			;;
		-f|--fetch)
			JUST_FETCH="jf"
			;;
		-e|--extra)
			EXTRA="extra"
			;;
		*)
			echo "Unrecognized Parameter $1"
			exit 1
	esac
	shift
done

if [[ "$CONTAINER" = "docker" ]]; then
	IS_DOCKER_GRP=$(groups | grep docker)
	if [[ ! -n "$IS_DOCKER_GRP" && $UID != 0 ]]; then
		echo -e "Permission Error: You must have root privilege or be part of the docker group to run with docker"
		exit 1
	fi
	#statements
fi

if [[ $NEW_CONTAINER = 1 ]]; then
	"$CONTAINER" build -t $NAME .
fi

if [[ $MANUAL = 1 ]]
then
	$CONTAINER run --rm --privileged --cpus $CPU -v /dev:/dev -v $PWD/output/:/output/ -v $PWD/input/:/input -it $NAME bash
else
	#echo "$CONTAINER run --rm --privileged --cpus $CPU -v /dev:/dev -v $PWD/output/:/output/ -v $PWD/input/:/input -it $NAME ./makeit.sh $SAVE_PROG $TYPE"
	$CONTAINER run --rm --privileged --cpus $CPU -v /dev:/dev -v $PWD/output/:/output/ -v $PWD/input/:/input -it $NAME ./makeit.sh $SAVE_PROG $TYPE $JUST_FETCH $EXTRA
fi
