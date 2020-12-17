#!/bin/sh

set -uxe

EXPECTED_PLATFORM=${1:-}

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
. "${SCRIPT_DIR}/functions.sh"

test "$EXPECTED_PLATFORM" = "$(detect_docker_platform)"
