#!/bin/sh

set -uex

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "${SCRIPT_DIR}/functions.sh"

OS=$1
REF=$2
PLATFORM=$3
TOOlCHAIN=$4
XTOOLS_DIR="${5:-${SCRIPT_DIR}/x-tools}"
SOURCES_DIR="${6:-${SCRIPT_DIR}/sources}"
CONFIGS_DIR="${7:-${SCRIPT_DIR}/configs/${OS}}"

IMAGE=$(generate_image_name "$OS" "$REF" "$PLATFORM")

docker pull \
  "ghcr.io/$IMAGE" \
  --platform "$PLATFORM" \
  || true

mkdir -p "$XTOOLS_DIR"
mkdir -p "$SOURCES_DIR"

docker run -it \
  --platform "$PLATFORM" \
  --mount "type=bind,src=${XTOOLS_DIR},dst=/root/x-tools" \
  --mount "type=bind,src=${SOURCES_DIR},dst=/root/src" \
  --mount "type=bind,src=${CONFIGS_DIR},dst=/root/configs" \
  "$IMAGE" \
  /scripts/build-toolchain.sh "$TOOLCHAIN"

# Remove log, its large
rm "${XTOOLS_DIR}/${TOOLCHAIN}/build.log.bz2"

# Package
cd "${XTOOLS_DIR}"
tar -cJf "${TOOLCHAIN}.tar.xz" "${TOOLCHAIN}"
