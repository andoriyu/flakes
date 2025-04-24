{ pkgs
, fenix
, system
, ...
}:
let
  rustPlatformStable = pkgs.makeRustPlatform {
    inherit (fenix.packages.${system}.stable) cargo rustc;
  };
  rustNightlyToolchain = fenix.packages.${system}.toolchainOf {
    date = "2023-03-23";
    sha256 = "sha256-PZ0RpKaEB1o2kkSUSMmPU4zRFPqC2VdPGUV+kQiQLFA=";
  }; # Specific date to avoid recompilcation every day
  st_0_8_14 = pkgs.callPackage ./packages/st { };
in
rec {
  atlas = pkgs.callPackage ./packages/atlas/default.nix { };
  dart-sass = dart-sass-1_60_0;
  git-cliff = pkgs.callPackage ./packages/git-cliff {
    rustPlatform = rustPlatformStable;
  };
  encodec = pkgs.callPackage ./packages/encodec {
    inherit (pkgs.python311Packagesf) buildPythonPackage;
  };
  bark = pkgs.callPackage ./packages/bark {
    inherit encodec; # makes the local copy visible
    inherit (pkgs.python311Packagesf) buildPythonPackage;
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
  dart-sass-1_59_3 =
    pkgs.callPackage ./packages/dart-sass-snapshot { version = "1.59.3"; };
  dart-sass-1_60_0 =
    pkgs.callPackage ./packages/dart-sass-snapshot { version = "1.60.0"; };

  strongdm-cli = pkgs.callPackage ./packages/sdm-cli { version = "33.57.0"; };
}
  // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
  City = pkgs.callPackage ./packages/city-theme { };
  st-onedark = st_0_8_14.overrideAttrs (oldAttrs: rec {
    configFile = ./packages/st/config.def.h-onedark;
    postPatch = ''
      ${oldAttrs.postPatch}
       cp ${configFile} config.def.h'';
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
  });
}
