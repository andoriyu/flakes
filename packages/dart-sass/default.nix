# Copyright 2020 Kyryl Vlasov
# SPDX-License-Identifier: MIT

{ stdenv
, fetchurl
, binutils
, version
, lib
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
  meta =
    let
      versions = (builtins.fromJSON (builtins.readFile ./versions.json));
      matches = x: x.version == version && x.platform == system;
    in
    lib.findFirst matches
      (throw "Don't know this version yet")
      versions;

  sha256 = meta.sha256;
  url = meta.url;
  archive_fmt = if stdenv.isDarwin then "zip" else "tar.gz";

in
stdenv.mkDerivation {
  name = "dart-sass-${version}";
  inherit version;

  isExecutable = true;

  src = fetchurl {
    inherit sha256 url;
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
