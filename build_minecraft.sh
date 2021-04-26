#!/bin/sh
set -e

cd minecraft

IMAGE_NAME=mbullington/minecraft
BUILD_IMAGE_NAME=$IMAGE_NAME:__build
BUILD_INSTANCE_NAME=mbullington_minecraft__build
VERSION_LONG=v1.0.0_1.16.5

# make sure a container with this image is not currently running
BUILD_CONTAINER_ID=$(docker ps -aqf name=$BUILD_INSTANCE_NAME)
if [[ "$BUILD_CONTAINER_ID" != "" ]]; then
  echo "killing $BUILD_INSTANCE_NAME with instance id $BUILD_CONTAINER_ID"
  docker kill $BUILD_CONTAINER_ID
fi

# build the image
echo "Building image. This might take a while..."
docker build -f Dockerfile -t $BUILD_IMAGE_NAME .

# launch detached container
docker run --rm --name $BUILD_INSTANCE_NAME -dit $BUILD_IMAGE_NAME /bin/sh

# commit changes to image, making :latest
BUILD_CONTAINER_ID=$(docker ps -aqf name=$BUILD_INSTANCE_NAME)
docker commit "${commit_args[@]}" $BUILD_CONTAINER_ID ${IMAGE_NAME}:latest

# kill & remove temporary container
docker kill $BUILD_CONTAINER_ID
docker rmi $BUILD_IMAGE_NAME

docker tag $IMAGE_NAME:latest $IMAGE_NAME:$VERSION_LONG

echo "You can push the image to Docker hub:"
echo "docker push $IMAGE_NAME:$VERSION_LONG"
echo "docker push $IMAGE_NAME:latest"
