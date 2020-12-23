#!/bin/sh

set -uex

CROSSTOOL_NG_VERSION=$1

git clone \
  https://github.com/elijahr/crosstool-ng.git \
  --branch master \
  --single-branch \
  crosstool-ng

cd crosstool-ng
git checkout $CROSSTOOL_NG_VERSION
./bootstrap
./configure --prefix=/usr/local
make
make install
cd -
rm -rf crosstool-ng
