{final, prev, ...}:
let
  pname = "cargo-expand";
  inherit (prev) cargo-expand;
  inherit (cargo-expand) version;
in final.runCommand "${pname}-${version}" {
              inherit pname version;
              inherit (cargo-expand) src meta;
              nativeBuildInputs = [ final.makeWrapper ];
} ''
  mkdir -p $out/bin
  makeWrapper ${cargo-expand}/bin/cargo-expand $out/bin/cargo-expand \
    --prefix PATH : ${prev.pkgs.rust-bin.nightly.latest.minimal}/bin
  ''

