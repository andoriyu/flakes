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
    '';
    fixupPhase = ''
      patchelf \
          --set-interpreter ${binutils.dynamicLinker} \
          $out/bin/sass
    '';
  }
