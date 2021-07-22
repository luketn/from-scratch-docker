#!/bin/bash

VERSION=${1:-v1}
ARCHITECTURES_TO_BUILD=${2:-"arm64,x86_64"}
TAG_NAME=${3:-"from-scratch-docker"}
DOCKERHUB_NAME=${4:-"luketn"}

TAG="${DOCKERHUB_NAME}/${TAG_NAME}:${VERSION}"

echo "Building version '${VERSION}' with architectures ${ARCHITECTURES_TO_BUILD} (${TAG})!"

TEMP_FILE=$(mktemp /tmp/from-scratch-push.XXXXXX)

docker login

ARCHITECTURES=$(echo $ARCHITECTURES_TO_BUILD | tr "," "\n")
for ARCHITECTURE in $ARCHITECTURES
do
  echo "Building $ARCHITECTURE"
  ./build-${ARCHITECTURE}.sh

  ARCHITECTURE_TAG="${TAG}-${ARCHITECTURE}"
  docker tag "${TAG_NAME}:${ARCHITECTURE}" "${ARCHITECTURE_TAG}"
  docker push "${ARCHITECTURE_TAG}"

  printf " ${ARCHITECTURE_TAG}" >> $TEMP_FILE
done

docker manifest create ${TAG}$(cat $TEMP_FILE)
docker manifest push --purge ${TAG}

LATEST_TAG="${DOCKERHUB_NAME}/${TAG_NAME}:latest"
docker manifest create ${LATEST_TAG}$(cat $TEMP_FILE)
docker manifest push --purge "${LATEST_TAG}"