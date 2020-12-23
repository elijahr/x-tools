FROM lopsided/archlinux:devel

ARG CROSSTOOL_NG_VERSION=54b8b91c1095e8def84699967a6c6389f5a224cb

WORKDIR /root

# Install deps, build crosstool-ng
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
    gcc-ada \
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

COPY configs/archlinux /root/configs/
COPY scripts /scripts/
COPY sources /root/src/
