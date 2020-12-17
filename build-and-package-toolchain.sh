#!/bin/sh

set -uex

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
. "${SCRIPT_DIR}/functions.sh"

OS=$1
REF=$2
RELEASE_NAME=$3
PLATFORM=$4
TOOLCHAIN=$5
XTOOLS_DIR="${6:-${SCRIPT_DIR}/x-tools}"
SOURCES_DIR="${7:-${SCRIPT_DIR}/sources}"
CONFIGS_DIR="${8:-${SCRIPT_DIR}/configs/${OS}}"

IMAGE="ghcr.io/$(generate_image_name "$OS" "$REF" "$PLATFORM")"

mkdir -p "$XTOOLS_DIR"
mkdir -p "$SOURCES_DIR"

docker run -t \
  --platform "$PLATFORM" \
  --mount "type=bind,src=${XTOOLS_DIR},dst=/root/x-tools" \
  --mount "type=bind,src=${SOURCES_DIR},dst=/root/src" \
  --mount "type=bind,src=${CONFIGS_DIR},dst=/root/configs" \
  "$IMAGE" \
  /scripts/build-toolchain.sh "$TOOLCHAIN"

# Remove log, its large
rm "${XTOOLS_DIR}/${TOOLCHAIN}/build.log"*

# Package
TARBALL="${XTOOLS_DIR}/${TOOLCHAIN}.tar.xz"
cd "$XTOOLS_DIR"
tar -cJf "$TARBALL" "$TOOLCHAIN"

ARCH=$(docker_platform_to_docker_arch "$PLATFORM")

echo "::set-output name=asset_path::${TARBAlL}"
echo "::set-output name=asset_name::x-tools-${RELEASE_NAME}--${OS}-${ARCH}--${TOOLCHAIN}.tar.xz"
