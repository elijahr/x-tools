

generate_image_name () {
  sed=$(which gsed || which sed) # needs gnu-sed
  tag="$1-$2-$(echo $3 | $sed -r 's/linux\///')"
  tag=$(echo $tag | $sed -r 's/[^a-zA-Z0-9.]+/-/g' | $sed -r 's/^-+\|-+$//g')
  echo "elijahr/crosstools-ng:$tag"
}

docker_platform_to_docker_arch () {
  # Normalize a docker platform (linux/arm/v7, etc) to one of the following:
  # - amd64
  # - 386
  # - arm32v5
  # - arm32v6
  # - arm32v7
  # - arm64v8
  # - ppc
  # - ppc64le
  # - s390x
  # - mips64le
  sed=$(which gsed || which sed) # needs gnu-sed
  echo $(echo "$1" | $sed 's/linux\///' | $sed 's/arm\//arm32/' | $sed 's/arm64\//arm64/')
}
