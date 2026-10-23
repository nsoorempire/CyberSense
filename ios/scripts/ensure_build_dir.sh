#!/bin/sh
# Keep iOS build products off iCloud Desktop / Documents.
#
# Finder and the file provider attach com.apple.FinderInfo to new bundles
# there. codesign rejects that and the simulator build exits 255.
# Dart output stays in ./build; only build/ios is redirected.
set -e

if [ -z "$SRCROOT" ]; then
  echo "error: SRCROOT is not set" >&2
  exit 1
fi

project_root="$(cd "$SRCROOT/.." && pwd)"
ios_build="$project_root/build/ios"
cache="${HOME}/Library/Caches/CyberSense/ios-build"

mkdir -p "$cache"

if [ -L "$ios_build" ]; then
  exit 0
fi

if [ -e "$ios_build" ]; then
  rm -rf "$ios_build"
fi

mkdir -p "$(dirname "$ios_build")"
ln -s "$cache" "$ios_build"
