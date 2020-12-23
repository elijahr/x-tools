#!/bin/sh

set -uex

git clone \
  https://github.com/crosstool-ng/crosstool-ng.git \
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
