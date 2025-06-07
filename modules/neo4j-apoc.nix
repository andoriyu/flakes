{
  config,
  lib,
  pkgs,
  ...
}: let
  apoc = pkgs.neo4j-apoc;
  cfg = config.services.neo4j;
  copyCmd = ''
    cp ${apoc}/share/java/apoc.jar ${cfg.directories.plugins}/apoc.jar
    chown neo4j ${cfg.directories.plugins}/apoc.jar
  '';
  extraConfig = ''
    dbms.security.procedures.unrestricted=apoc.*
    dbms.security.procedures.allowlist=apoc.*
  '';
in {
  config = lib.mkIf config.services.neo4j.enable {
    systemd.services.neo4j.preStart = lib.mkAfter copyCmd;
    services.neo4j.extraServerConfig = lib.mkAfter extraConfig;
  };
}
