FROM alpine:3.12

ARG CROSSTOOL_NG_VERSION=54b8b91c1095e8def84699967a6c6389f5a224cb

WORKDIR /root

# Install deps, build crosstool-ng
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
    texinfo \
    util-linux \
    wget \
    xz

# Build crosstool-ng
RUN \
  git clone \
    https://github.com/crosstool-ng/crosstool-ng.git \
    --branch master \
    --single-branch \
    crosstool-ng && \
  cd crosstool-ng && \
  git checkout $CROSSTOOL_NG_VERSION && \
  ./bootstrap && \
  ./configure --prefix=/usr/local && \
  make && \
  make install && \
  cd .. && \
  rm -rf crosstool-ng

COPY configs/alpine3.12 /root/configs/
COPY sources /root/src/

ARG ENTRY_1
ENV ENTRY_1=$ENTRY_1

ARG ENTRY_2
ENV ENTRY_2=$ENTRY_2

ENTRYPOINT [$ENTRY_1, $ENTRY_2]
