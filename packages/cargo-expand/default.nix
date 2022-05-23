{ cargo-expand, runCommand, makeWrapper, toolchain, ... }:
let
  pname = cargo-expand.pname;
  version = cargo-expand.version;
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

