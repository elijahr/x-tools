#!/bin/sh

set -uxe

TOOLCHAIN=$1

# Workaround for incorrect strip being used during ncurses build
mkdir -p /usr/local/sbin
rm -f /usr/local/sbin/strip
ln -s \
  "/usr/lib/gcc-cross/${TOOLCHAIN}/${TOOLCHAIN}/bin/strip" \
  /usr/local/sbin/strip

mkdir -p /usr/lib/gcc-cross

chown -R ct-ng:ct-ng /usr/lib/gcc-cross
chown -R ct-ng:ct-ng /home/ct-ng

find /home/ct-ng -type d -exec sh -c 'echo; echo {}; ls -al {}'  \;
find /usr/lib/gcc-cross -type d -exec sh -c 'echo; echo {}; ls -al {}'  \;

cd "/home/ct-ng/configs/${TOOLCHAIN}"
sudo -u ct-ng ct-ng build
