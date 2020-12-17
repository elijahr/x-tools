#!/bin/sh

set -uxe

TOOLCHAIN=$1

cd "/root/configs/${TOOLCHAIN}"

# Workaround for incorrect strip being used during ncurses build
mkdir -p /usr/local/sbin
rm -f /usr/local/sbin/strip
ln -s \
  "/root/x-tools/${TOOLCHAIN}/${TOOLCHAIN}/bin/strip" \
  /usr/local/sbin/strip

ct-ng build
