{
  lib,
  stdenv,
  fetchurl,
}: let
  version = "5.26.1";
in
  stdenv.mkDerivation {
    pname = "neo4j-apoc";
    inherit version;

    src = fetchurl {
      url = "https://github.com/neo4j/apoc/releases/download/${version}/apoc-${version}-core.jar";
      sha256 = "sha256-Mc38FTqSgIjD0Scu+9C0tC5r/pEVOoXrPgGmY/QcMAY=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/java
      cp $src $out/share/java/apoc.jar
    '';

    meta = with lib; {
      description = "APOC plugin for Neo4j";
      homepage = "https://github.com/neo4j/apoc";
      license = licenses.asl20;
      platforms = platforms.all;
    };
  }
