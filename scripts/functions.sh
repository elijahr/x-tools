
normalize_to_docker_platform () {
  # Function to detect the current running container's platform and
  # normalize it to one of the following:
  # - linux/amd64
  # - linux/386
  # - linux/arm/v5
  # - linux/arm/v6
  # - linux/arm/v7
  # - linux/arm64/v8
  # - linux/ppc
  # - linux/ppc64le
  # - linux/s390x
  # - linux/mips64le

  ACTUAL_PLATFORM=$(uname -m)

  case $ACTUAL_PLATFORM in
    x86_64 | x64)
      # Detect 386 container on amd64 using __amd64 definition
      IS_AMD64=$(gcc -dM -E - < /dev/null | grep "#define __amd64 " | sed 's/#define __amd64 //')
      if [ "$IS_AMD64" = "1" ]
      then
        echo linux/amd64
      else
        echo linux/386
      fi
      ;;
    386 | i686 | x86)
      echo linux/386 ;;
    aarch64 | arm64 | armv8b | armv8l)
      echo linux/arm64/v8 ;;
    arm*)
      # Detect arm/ version using __ARM_PLATFORM definition
      ARM_PLATFORM=$(gcc -dM -E - < /dev/null | grep "#define __ARM_PLATFORM " | sed 's/#define __ARM_PLATFORM //')
      echo linux/arm/v$ARM_PLATFORM
      ;;
    mips64)
      echo mips64le ;;
    ppc | ppc64le | s390x)
      echo linux/$ACTUAL_PLATFORM ;;
    *)
      echo "Unhandled platform $ACTUAL_PLATFORM" 1>&2
      exit 1
      ;;
  esac
}
