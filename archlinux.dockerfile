FROM archlinux:base-devel

# non-amd64
# FROM lopsided/archlinux:devel

ARG CROSSTOOL_NG_VERSION=dtc-1.6.0

# Install deps
RUN \
  pacman -Syu --noconfirm \
    autoconf \
    automake \
    bash \
    bison \
    coreutils \
    dejagnu \
    distcc \
    flex \
    gawk \
    gcc \
    gettext \
    git \
    gmp \
    help2man \
    libtool \
    make \
    libmpc \
    mpfr \
    ncurses \
    python2 \
    rsync \
    texinfo \
    unzip \
    wget \
    xz && \
  pacman -Sc --noconfirm || true;

# amd64-only
RUN \
  pacman -Syu --noconfirm gcc-ada && \
  pacman -Sc --noconfirm || true;

RUN useradd -d /home/ct-ng -Ums /bin/sh ct-ng
COPY configs/archlinux /home/ct-ng/configs/
COPY scripts /scripts/
COPY sources /home/ct-ng/src/

WORKDIR /home/ct-ng

# Build crosstool-ng
RUN sh /scripts/install-ct-ng.sh $CROSSTOOL_NG_VERSION
RUN chown -R ct-ng:ct-ng /home/ct-ng
