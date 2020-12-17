#!/bin/sh

set -uxe

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
. "${SCRIPT_DIR}/functions.sh"

case "$(normalize_to_docker_platform)" in
  linux/386)
    # Workaround for docker, where 32-bit containers running on 64-bit
    # kernels so uname -m shows x86_64.
    exec /usr/bin/setarch i686 $@
    ;;
  *)
    exec $@
    ;;
esac
