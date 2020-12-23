#!/bin/sh

set -uxe

TOOLCHAIN=$1

cd "/home/ct-ng/configs/${TOOLCHAIN}"

# Workaround for incorrect strip being used during ncurses build
mkdir -p /usr/local/sbin
rm -f /usr/local/sbin/strip
ln -s \
  "/usr/lib/gcc-cross/${TOOLCHAIN}/${TOOLCHAIN}/bin/strip" \
  /usr/local/sbin/strip

chown -R ct-ng:ct-ng /usr/lib/gcc-cross
sudo -u ct-ng ct-ng build
