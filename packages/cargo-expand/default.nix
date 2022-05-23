{ pkgs, toolchain, ... }:
let
  pname = pkgs.cargo-expand.pname;
  version = pkgs.cargo-expand.version;
in
pkgs.runCommand "${pname}-${version}"
{
  inherit (pkgs.cargo-expand) src meta pname version;
  nativeBuildInputs = [ pkgs.makeWrapper ];
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.cargo-expand}/bin/cargo-expand $out/bin/cargo-expand \
    --prefix PATH : ${toolchain}/bin
''

