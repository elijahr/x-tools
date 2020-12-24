# x-tools

x-tools is a repository for cross compiler configurations and build scripts for a variety of hosts and architectures.

The projects main goal is to provide binary cross compiler toolchains for use in docker containers. The toolchains, scripts, and configuration files herein are likely useful for other purposes.

x-tools uses Docker and [crosstool-ng](https://crosstool-ng.github.io/).

## Toolchains

### Alpine Linux 3.12

* host: x86_64
  * armv6-alpine-linux-musleabihf
  * armv7-alpine-linux-musleabihf
  * aarch64-alpine-linux-musl
  * powerpc64le-alpine-linux-musl
  * i686-alpine-linux-musl
  
### Arch Linux

* host: x86_64
  * armv5tel-unknown-linux-gnueabi
  * armv6l-unknown-linux-gnueabihf
  * armv7l-unknown-linux-gnueabihf
  * aarch64-unknown-linux-gnu
