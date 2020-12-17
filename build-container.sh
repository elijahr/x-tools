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

mkdir -p "${SCRIPT_DIR}/sources"

docker build \
  --file "${SCRIPT_DIR}/${OS}.dockerfile" \
  --build-arg PLATFORM="$PLATFORM" \
  --platform "$PLATFORM" \
  --cache-from "ghcr.io/$IMAGE" \
  --tag "$IMAGE" \
  "${SCRIPT_DIR}"

docker tag "$IMAGE" "ghcr.io/$IMAGE"
docker push "ghcr.io/$IMAGE"
