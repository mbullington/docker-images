#!/bin/sh
set -e

IMAGE_NAME=mbullington/emsdk
EMSCRIPTEN_VERSION=2.0.14
BUILD_IMAGE_NAME=$IMAGE_NAME:__build
BUILD_INSTANCE_NAME=mbullington_emsdk__build

# make sure a container with this image is not currently running
BUILD_CONTAINER_ID=$(docker ps -aqf name=$BUILD_INSTANCE_NAME)
if [[ "$BUILD_CONTAINER_ID" != "" ]]; then
  echo "killing $BUILD_INSTANCE_NAME with instance id $BUILD_CONTAINER_ID"
  docker kill $BUILD_CONTAINER_ID
fi

# build the image
echo "Building image. This might take a while..."
docker build -f Dockerfile -t $BUILD_IMAGE_NAME .
# docker build -f Dockerfile -t $BUILD_IMAGE_NAME .

# launch detached container
docker run --rm --name $BUILD_INSTANCE_NAME -dit $BUILD_IMAGE_NAME /bin/bash

# commit changes to image, making :latest
BUILD_CONTAINER_ID=$(docker ps -aqf name=$BUILD_INSTANCE_NAME)
docker commit "${commit_args[@]}" $BUILD_CONTAINER_ID ${IMAGE_NAME}:latest

# kill & remove temporary container
docker kill $BUILD_CONTAINER_ID
docker rmi $BUILD_IMAGE_NAME

docker tag $IMAGE_NAME:latest $IMAGE_NAME:$EMSCRIPTEN_VERSION

echo "Testing the image: building test case"
cd example
docker run --rm -v "$PWD:/src" $IMAGE_NAME:$EMSCRIPTEN_VERSION emcc hello.c -s WASM=1 -o hello.js
if which node >/dev/null; then
  echo node hello.js
  node hello.js
fi

echo "You can push the image to Docker hub:"
echo "docker push $IMAGE_NAME:$EMSCRIPTEN_VERSION"
echo "docker push $IMAGE_NAME:latest"

# docker run --rm -it -v "$PWD:/src" rsms/emsdk:latest
