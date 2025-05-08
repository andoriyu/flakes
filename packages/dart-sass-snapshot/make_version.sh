#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "$0")"

declare -A PLATFORMS=(
    [macos-x64]=x86_64-darwin
    [macos-arm64]=aarch64-darwin
    [linux-x64]=x86_64-linux
    [linux-arm64]=aarch64-linux
)

BASE="https://github.com/sass/dart-sass/releases/download"
VERSION=$1
TMP=versions.tmp.json


echo '' > $TMP

for platform in "${!PLATFORMS[@]}"; do
  # https://github.com/sass/dart-sass/releases/download/1.52.1/dart-sass-1.52.1-linux-arm64.tar.gz"
  url="${BASE}/${VERSION}/dart-sass-${VERSION}-${platform}.tar.gz"
  sha256=$(nix store prefetch-file --json "${url}" | jq -r '.hash')
  nixPlatform=${PLATFORMS[$platform]}
  jq --arg version "$VERSION" \
    --arg platform "$nixPlatform" \
    --arg url "$url" \
    --arg sha256 "$sha256" \
    -n '$ARGS.named' >> $TMP
done

jq -s '.' $TMP > $TMP.arr
jq -s '.[0] + .[1]' $TMP.arr versions.json > versions-new.json
mv versions-new.json versions.json
rm $TMP $TMP.arr
cd -
