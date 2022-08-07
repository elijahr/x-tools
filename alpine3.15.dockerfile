FROM alpine:3.15

ARG CROSSTOOL_NG_VERSION=dtc-1.6.1

# Install deps
RUN \
  apk add --no-cache \
    alpine-sdk \
    autoconf \
    automake \
    bash \
    bison \
    coreutils \
    dejagnu \
    distcc \
    flex \
    g++ \
    gawk \
    gcc \
    gcc-gnat \
    gettext-dev \
    git \
    gmp \
    gmp-dev \
    help2man \
    libtool \
    make \
    mpc1 \
    mpc1-dev \
    mpfr-dev \
    mpfr4 \
    ncurses \
    ncurses-dev \
    python2 \
    python2-dev \
    rsync \
    sudo \
    texinfo \
    util-linux \
    wget \
    xz

COPY configs/alpine3.15 /home/ct-ng/configs/
COPY scripts /scripts/
COPY sources /home/ct-ng/src/

RUN adduser -D -g '' ct-ng
WORKDIR /home/ct-ng

# Build crosstool-ng
RUN sh /scripts/install-ct-ng.sh $CROSSTOOL_NG_VERSION
RUN chown -R ct-ng:ct-ng /home/ct-ng
