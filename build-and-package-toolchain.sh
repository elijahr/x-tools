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

IMAGE="ghcr.io/$(generate_image_name "$OS" "$REF" "$PLATFORM")"

mkdir -p "$GCC_CROSS_DIR"
mkdir -p "$SOURCES_DIR"

docker run -t \
  --platform "$PLATFORM" \
  --mount "type=bind,src=${GCC_CROSS_DIR},dst=/usr/lib/gcc-cross" \
  --mount "type=bind,src=${SOURCES_DIR},dst=/home/ct-ng/src" \
  --mount "type=bind,src=${SCRIPT_DIR}/scripts,dst=/scripts" \
  "$IMAGE" \
  /scripts/build-toolchain.sh "$TOOLCHAIN"

# Remove log if it exists, its large
rm -f "${GCC_CROSS_DIR}/${TOOLCHAIN}/build.log"*

# Adjust permissions
sudo chown -R "$(whoami)" "$GCC_CROSS_DIR"

# Package
TARBALL="${TOOLCHAIN}.tar.xz"
cd "$GCC_CROSS_DIR"
find .
tar -cJf "$TARBALL" "$TOOLCHAIN"
cd -
echo "::set-output name=asset_path::${GCC_CROSS_DIR}/${TARBALL}"

ARCH=$(docker_platform_to_docker_arch "$PLATFORM")
echo "::set-output name=asset_name::x-tools--host.${OS}-${ARCH}--target.${TOOLCHAIN}--${RELEASE_NAME}.tar.xz"
