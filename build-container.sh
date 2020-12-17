#!/bin/sh

set -uex

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
. "${SCRIPT_DIR}/functions.sh"

OS=$1
REF=$2
PLATFORM=$3

IMAGE=$(generate_image_name "$OS" "$REF" "$PLATFORM")

docker pull \
  "ghcr.io/$IMAGE" \
  --platform "$PLATFORM" \
  || true

cd "${SCRIPT_DIR}"
docker build \
  --file "${SCRIPT_DIR}/${OS}.dockerfile" \
  --build-arg PLATFORM="$PLATFORM" \
  --platform "$PLATFORM" \
  --tag "$IMAGE" \
  .
cd -

docker push "ghcr.io/$IMAGE"
