FROM alpine:3.12

ARG CROSSTOOL_NG_VERSION=54b8b91c1095e8def84699967a6c6389f5a224cb

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
    sudo \
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

COPY configs/alpine3.12 /home/ct-ng/configs/
COPY scripts /scripts/
COPY sources /home/ct-ng/src/

RUN adduser -D -g '' ct-ng
WORKDIR /home/ct-ng

# Build crosstool-ng
RUN sh /scripts/install-ct-ng.sh
RUN \
  mkdir -p /usr/lib/gcc-cross && \
  chown -R ct-ng:ct-ng /usr/lib/gcc-cross && \
  chown -R ct-ng:ct-ng /home/ct-ng
