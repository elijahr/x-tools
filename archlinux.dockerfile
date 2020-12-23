FROM lopsided/archlinux:devel

ARG CROSSTOOL_NG_VERSION=54b8b91c1095e8def84699967a6c6389f5a224cb

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

COPY configs/archlinux /home/ct-ng/configs/
COPY scripts /scripts/
COPY sources /home/ct-ng/src/

RUN useradd -ms /bin/sh ct-ng
WORKDIR /home/ct-ng

# Build crosstool-ng
RUN sh /scripts/install-ct-ng.sh
RUN \
  mkdir -p /usr/lib/gcc-cross && \
  chown -R ct-ng:ct-ng /usr/lib/gcc-cross && \
  chown -R ct-ng:ct-ng /home/ct-ng
