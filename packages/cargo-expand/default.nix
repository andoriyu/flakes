{ cargo-expand, runCommand, makeWrapper, toolchain, ... }:
let
  inherit (cargo-expand) pname;
  inherit (cargo-expand) version;
in
runCommand "${pname}-${version}"
{
  inherit (cargo-expand) src meta pname version;
  nativeBuildInputs = [ makeWrapper ];
} ''
  mkdir -p $out/bin
  makeWrapper ${cargo-expand}/bin/cargo-expand $out/bin/cargo-expand \
    --prefix PATH : ${toolchain.toolchain}/bin
''

