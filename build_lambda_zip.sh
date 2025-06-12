#!/bin/bash
set -e
FUNC_FILE=$1
ZIP_FILE=$2
echo "Building Lambda zip for ${FUNC_FILE} → ${ZIP_FILE}"
docker build \
  -f DockerFile \
  --build-arg FUNCTION_FILE=$FUNC_FILE \
  --build-arg ZIP_NAME=$ZIP_FILE \
  -t lambda-builder-temp .

docker run --rm -v "$PWD:/out" lambda-builder-temp cp "/${ZIP_FILE}" /out

echo "Created: ${ZIP_FILE}"
