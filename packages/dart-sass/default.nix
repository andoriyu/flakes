# Copyright 2020 Kyryl Vlasov
# SPDX-License-Identifier: MIT

{ stdenv
, fetchurl
, binutils
, platformsSha256
, version
}:

let
  inherit (stdenv.hostPlatform) system;

  plat = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "darwin";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux = "linux-armhf";
  }.${system};
  sha256 = platformsSha256.${system};
  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

in
stdenv.mkDerivation {
  name = "dart-sass-${version}";
  inherit version;

  isExecutable = true;

  src = fetchurl {
    inherit sha256;
    url = builtins.concatStringsSep "/" [
      "https://github.com"
      "sass/dart-sass/releases/download"
      "${version}/dart-sass-${version}-${plat}.${archive_fmt}"
    ];
  };
  phases = "unpackPhase installPhase fixupPhase";

  sourceRoot = "./dart-sass";
  installPhase = ''
    install -m755 -D sass $out/bin/sass
  '';
  fixupPhase = ''
    patchelf \
        --set-interpreter ${binutils.dynamicLinker} \
        $out/bin/sass
  '';
}
