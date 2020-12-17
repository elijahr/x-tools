# x-tools

x-tools is a repository for cross compiler configurations and build scripts for a variety of hosts and architectures.

The projects main goal is to provide binary cross crompiler toolchains for use in docker containers, but the toolchains, scripts, and configuration files herein are likely useful for other purposes.

x-tools uses Docker and [crosstool-ng](https://crosstool-ng.github.io/).

Currently, toolchains are built for Alpine Linux 3.12 hosting and targetting all of the following architectures:

* amd64
* 386
* arm/v6
* arm/v7
* arm64/v8
* ppc64le
* s390x
