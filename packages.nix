{
  pkgs,
  fenix,
  system,
  ...
}: let
  st_0_8_14 = pkgs.callPackage ./packages/st {};
  neo4j-mcp-packages = pkgs.callPackage ./packages/neo4j-mcp {};
in
  rec {
    dart-sass = dart-sass-1_89_1;
    encodec = pkgs.callPackage ./packages/encodec {
      inherit (pkgs.python311Packages) buildPythonPackage;
    };
    bark = pkgs.callPackage ./packages/bark {
      inherit encodec; # makes the local copy visible
      inherit (pkgs.python311Packages) buildPythonPackage;
    };
    dart-sass-1_89_1 =
      pkgs.callPackage ./packages/dart-sass-snapshot {version = "1.89.1";};
    dart-sass-1_60_0 =
      pkgs.callPackage ./packages/dart-sass-snapshot {version = "1.60.0";};
    mcp-language-server = pkgs.callPackage ./packages/mcp-language-server {};

    # Neo4j MCP servers
    inherit
      (neo4j-mcp-packages)
      mcp-neo4j-cypher
      mcp-neo4j-memory
      mcp-neo4j-cloud-aura-api
      ;

    # Utility scripts
    wait-for-pr-checks = pkgs.callPackage ./packages/wait-for-pr-checks {};

    github-mcp-server = pkgs.callPackage ./packages/github-mcp-server {};
    mcp-inspector = pkgs.callPackage ./packages/mcp-inspector {};
    mcp-prompts = pkgs.callPackage ./packages/mcp-prompts {};
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
