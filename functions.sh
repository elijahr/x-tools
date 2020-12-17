

generate_image_name () {
  sed=$(which gsed || which sed) # needs gnu-sed
  tag="$1-$2-$(echo $3 | $sed -r 's/linux\///')"
  tag=$(echo $tag | $sed -r 's/[^a-zA-Z0-9.]+/-/g' | $sed -r 's/^-+\|-+$//g')
  echo "elijahr/crosstools-ng:$tag"
}
