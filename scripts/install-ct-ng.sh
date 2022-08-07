#!/bin/sh

set -uex

CROSSTOOL_NG_VERSION=$1

git clone \
  https://github.com/crosstool-ng/crosstool-ng.git \
  --branch $CROSSTOOL_NG_VERSION \
  --single-branch \
  crosstool-ng

cd crosstool-ng
./bootstrap
./configure --prefix=/usr/local
make
make install
cd -
rm -rf crosstool-ng
