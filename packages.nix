{
  pkgs,
  fenix,
  system,
  ...
}: let
  st_0_8_14 = pkgs.callPackage ./packages/st {};
in
  rec {
    dart-sass = dart-sass-1_60_0;
    encodec = pkgs.callPackage ./packages/encodec {
      inherit (pkgs.python311Packages) buildPythonPackage;
    };
    bark = pkgs.callPackage ./packages/bark {
      inherit encodec; # makes the local copy visible
      inherit (pkgs.python311Packages) buildPythonPackage;
    };
    dart-sass-1_52_1 =
      pkgs.callPackage ./packages/dart-sass {version = "1.52.1";};
    dart-sass-1_52_2 =
      pkgs.callPackage ./packages/dart-sass {version = "1.52.2";};
    dart-sass-1_53_0 =
      pkgs.callPackage ./packages/dart-sass {version = "1.53.0";};
    dart-sass-1_54_4 =
      pkgs.callPackage ./packages/dart-sass {version = "1.54.4";};
    dart-sass-1_57_1 =
      pkgs.callPackage ./packages/dart-sass {version = "1.57.1";};
    dart-sass-1_58_0 =
      pkgs.callPackage ./packages/dart-sass-snapshot {version = "1.58.0";};
    dart-sass-1_59_3 =
      pkgs.callPackage ./packages/dart-sass-snapshot {version = "1.59.3";};
    dart-sass-1_60_0 =
      pkgs.callPackage ./packages/dart-sass-snapshot {version = "1.60.0";};
    mcp-language-server = pkgs.callPackage ./packages/mcp-language-server {};

    strongdm-cli = pkgs.callPackage ./packages/sdm-cli {version = "33.57.0";};
    github-mcp-server = pkgs.callPackage ./packages/github-mcp-server {};
  }
  // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
    City = pkgs.callPackage ./packages/city-theme {};
    st-onedark = st_0_8_14.overrideAttrs (oldAttrs: rec {
      configFile = ./packages/st/config.def.h-onedark;
      postPatch = ''
        ${oldAttrs.postPatch}
         cp ${configFile} config.def.h'';
      buildInputs = oldAttrs.buildInputs ++ [pkgs.harfbuzz];
    });
  }
