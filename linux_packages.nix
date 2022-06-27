{ pkgs, fenix, system, ... }:
let
  st_0_8_14 = pkgs.callPackage ./packages/st { };
in
rec {
  st-onedark = st_0_8_14.overrideAttrs (oldAttrs: rec {
    configFile = ./packages/st/config.def.h-onedark;
    postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
  });
  City = pkgs.callPackage ./packages/city-theme { };
}
