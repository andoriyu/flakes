# Copyright 2020 Kyryl Vlasov
# SPDX-License-Identifier: MIT
{
  stdenv,
  fetchurl,
  binutils,
  version,
  lib,
}: let
  inherit (stdenv.hostPlatform) system;

  meta = let
    versions = builtins.fromJSON (builtins.readFile ./versions.json);
    matches = x: x.version == version && x.platform == system;
  in
    lib.findFirst matches (throw "Don't know this version yet") versions;
in
  stdenv.mkDerivation {
    name = "dart-sass-${version}";
    inherit version;

    isExecutable = true;

    src = fetchurl {inherit (meta) sha256 url;};
    phases = "unpackPhase installPhase fixupPhase";

    sourceRoot = "./dart-sass";
    installPhase = ''
      install -m755 -D sass $out/bin/sass
      install -m755 -D src/dart $out/bin/src/dart
      install -m755 -D src/sass.snapshot $out/bin/src/sass.snapshot
    '';
    fixupPhase = lib.optionalString (!stdenv.isDarwin) ''
      patchelf \
          --set-interpreter ${binutils.dynamicLinker} \
          $out/bin/src/dart
    '';
  }
