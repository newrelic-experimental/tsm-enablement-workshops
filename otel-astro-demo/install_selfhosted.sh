#!/usr/bin/env bash

# This script builds a custom version of the front end image to allow for insertion of browser agent.

echo -e "Building front end image..."

export selfhosted=true

BUILD_FOLDER="imagebuilder"

mkdir $BUILD_FOLDER
wget https://github.com/open-telemetry/opentelemetry-demo/archive/refs/tags/1.10.0.zip -P $BUILD_FOLDER
unzip "$BUILD_FOLDER/1.10.0.zip" -d "$BUILD_FOLDER/demo"
mkdir "$BUILD_FOLDER/demo/src"
cp -R "$BUILD_FOLDER/demo/opentelemetry-demo-1.10.0/src/frontend" "$BUILD_FOLDER/demo/src/"
cp -R "$BUILD_FOLDER/demo/opentelemetry-demo-1.10.0/pb" "$BUILD_FOLDER/demo/"
cp ../.devcontainer/otel-astro/frontend_image/docker-compose.yaml "$BUILD_FOLDER/demo"
cp ../.devcontainer/otel-astro/frontend_image/_document.tsx "$BUILD_FOLDER/demo/src/frontend/pages/"
rm $BUILD_FOLDER/demo/opentelemetry-demo-1.10.0 -rf

docker compose -f $BUILD_FOLDER/demo/docker-compose.yaml build

rm -rf $BUILD_FOLDER

#add image to minikube  cache
echo -e "\n\n Loading image into minikube... this may take a few minutes..."
minikube image load docker.io/nr-astro-otel-demo/local-frontend:latest

echo -e "\nFrontend image is built, starting demo install script."

../.devcontainer/otel-astro/install_demo.sh
