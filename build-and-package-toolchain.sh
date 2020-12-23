#!/bin/sh

set -uex

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
. "${SCRIPT_DIR}/functions.sh"

OS=$1
REF=$2
RELEASE_NAME=$3
PLATFORM=$4
TOOLCHAIN=$5
GCC_CROSS_DIR="${6:-${SCRIPT_DIR}/gcc-cross}"
SOURCES_DIR="${7:-${SCRIPT_DIR}/sources}"
CONFIGS_DIR="${8:-${SCRIPT_DIR}/configs/${OS}}"

IMAGE="ghcr.io/$(generate_image_name "$OS" "$REF" "$PLATFORM")"

mkdir -p "$GCC_CROSS_DIR"
mkdir -p "$SOURCES_DIR"

docker run -t \
  --platform "$PLATFORM" \
  --mount "type=bind,src=${GCC_CROSS_DIR},dst=/usr/lib/gcc-cross" \
  --mount "type=bind,src=${SOURCES_DIR},dst=/home/ct-ng/src" \
  --mount "type=bind,src=${CONFIGS_DIR},dst=/home/ct-ng/configs" \
  --mount "type=bind,src=${SCRIPT_DIR}/scripts,dst=/scripts" \
  "$IMAGE" \
  /scripts/build-toolchain.sh "$TOOLCHAIN"

# Remove log if it exists, its large
rm -f "${GCC_CROSS_DIR}/${TOOLCHAIN}/build.log"*

# Package
TARBALL="${GCC_CROSS_DIR}/${TOOLCHAIN}.tar.xz"
cd "$GCC_CROSS_DIR"
tar -cJf "$TARBALL" "$TOOLCHAIN"

ARCH=$(docker_platform_to_docker_arch "$PLATFORM")

echo "::set-output name=asset_path::${TARBALL}"
echo "::set-output name=asset_name::x-tools-${RELEASE_NAME}--${OS}-${ARCH}--${TOOLCHAIN}.tar.xz"
