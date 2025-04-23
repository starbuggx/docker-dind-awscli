#!/bin/sh
set -exu
docker buildx build --platform linux/amd64 -t starbuggx/dind-awscli:latest "."
docker buildx build --platform linux/amd64 -t starbuggx/dind-awscli:dind -f Dockerfile.dind "."

FULLVER=$(docker run -t --rm  starbuggx/dind-awscli aws --version)
#echo "AWS CLI complete versionstring: $FULLVER"
VER=$(echo $FULLVER | cut -f 1 -d ' ' | cut -f 2 -d '/')
#echo "Extracted AWS CLI Version: $VER"
DOCKERFULLVER=$(docker run -t --rm  starbuggx/dind-awscli docker --version)
#echo "Docker CLI complete versionstring: $VER"
DOCKERVER=$(echo $DOCKERFULLVER | cut -f 3 -d ' ' | cut -f 1 -d ',')
#echo "Extracted Docker CLI Version: $DOCKERVER"

#echo "Tagging starbuggx/dind-awscli:$VER-$DOCKERVER"
docker tag starbuggx/dind-awscli:latest starbuggx/dind-awscli:$VER-docker-$DOCKERVER
#echo "Tagging starbuggx/dind-awscli:dind-$VER-$DOCKERVER"
docker tag starbuggx/dind-awscli:dind starbuggx/dind-awscli:$VER-dind-$DOCKERVER

docker push starbuggx/dind-awscli:$VER-docker-$DOCKERVER
docker push starbuggx/dind-awscli:$VER-dind-$DOCKERVER
docker push starbuggx/dind-awscli:latest
docker push starbuggx/dind-awscli:dind