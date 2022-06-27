{ pkgs, fenix, system, ... }:
let
  rustPlatformStable = pkgs.makeRustPlatform {
    inherit (fenix.packages.${system}.stable) cargo rustc;
  };
  rustNightlyToolchain = fenix.packages.${system}.toolchainOf {
    date = "2022-05-25";
    sha256 = "sha256-zjx9Ogl5ZyJOWq/1byndSStGQiIzmw0NamzmVGmUZbY=";
  }; # Specific date to avoid recompilcation every day
  st_0_8_14 = pkgs.callPackage ./packages/st { };
in
rec {
  atlas = pkgs.callPackage ./packages/atlas/default.nix { };
  dart-sass = dart-sass-1_53_0;
  git-cliff = pkgs.callPackage ./packages/git-cliff { rustPlatform = rustPlatformStable; };
  cargo-expand-nightly = pkgs.callPackage ./packages/cargo-expand { toolchain = rustNightlyToolchain; };
  dart-sass-1_52_1 = pkgs.callPackage ./packages/dart-sass {
    version = "1.52.1";
  };
  dart-sass-1_52_2 = pkgs.callPackage ./packages/dart-sass {
    version = "1.52.2";
  };
  dart-sass-1_53_0 = pkgs.callPackage ./packages/dart-sass {
    version = "1.53.0";
  };
  st-onedark = st_0_8_14.overrideAttrs (oldAttrs: rec {
    configFile = ./packages/st/config.def.h-onedark;
    postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
  });
  strongdm-cli = pkgs.callPackage ./packages/sdm-cli {
    version = "33.57.0";
  };
  City = pkgs.lib.mkIf pkgs.stdenv.isLinux pkgs.callPackage ./packages/city-theme { };
}
