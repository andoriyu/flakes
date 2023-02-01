{ pkgs, fenix, system, ... }:
let
  rustPlatformStable = pkgs.makeRustPlatform {
    inherit (fenix.packages.${system}.stable) cargo rustc;
  };
  rustNightlyToolchain = fenix.packages.${system}.toolchainOf {
    date = "2022-08-11";
    sha256 = "sha256-wVnIzrnpYGqiCBtc3k55tw4VW8YLA3WZY0mSac+2yl0=";
  }; # Specific date to avoid recompilcation every day
  st_0_8_14 = pkgs.callPackage ./packages/st { };
in
rec {
  atlas = pkgs.callPackage ./packages/atlas/default.nix { };
  dart-sass = dart-sass-1_58_0;
  git-cliff = pkgs.callPackage ./packages/git-cliff {
    rustPlatform = rustPlatformStable;
  };
  doctave =
    pkgs.callPackage ./packages/doctave { rustPlatform = rustPlatformStable; };
  cargo-expand-nightly = pkgs.callPackage ./packages/cargo-expand {
    toolchain = rustNightlyToolchain;
  };
  dart-sass-1_52_1 =
    pkgs.callPackage ./packages/dart-sass { version = "1.52.1"; };
  dart-sass-1_52_2 =
    pkgs.callPackage ./packages/dart-sass { version = "1.52.2"; };
  dart-sass-1_53_0 =
    pkgs.callPackage ./packages/dart-sass { version = "1.53.0"; };
  dart-sass-1_54_4 =
    pkgs.callPackage ./packages/dart-sass { version = "1.54.4"; };
  dart-sass-1_57_1 =
    pkgs.callPackage ./packages/dart-sass { version = "1.57.1"; };
  dart-sass-1_58_0 =
    pkgs.callPackage ./packages/dart-sass-snapshot { version = "1.58.0"; };

  strongdm-cli = pkgs.callPackage ./packages/sdm-cli { version = "33.57.0"; };
} // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
  City = pkgs.callPackage ./packages/city-theme { };
  st-onedark = st_0_8_14.overrideAttrs (oldAttrs: rec {
    configFile = ./packages/st/config.def.h-onedark;
    postPatch = ''
      ${oldAttrs.postPatch}
       cp ${configFile} config.def.h'';
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
  });
}
