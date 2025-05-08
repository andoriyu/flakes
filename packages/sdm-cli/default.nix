{
  stdenv,
  fetchzip,
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
    name = "strongdm-cli";
    inherit version;
    src = fetchzip {inherit (meta) sha256 url;};
    phases = "installPhase fixupPhase";

    installPhase = ''
      install -m755 -D $src/sdm $out/bin/sdm
    '';
  }
