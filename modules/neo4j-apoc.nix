{
  config,
  lib,
  pkgs,
  ...
}: let
  apoc = pkgs.neo4j-apoc;
  cfg = config.services.neo4j;
  copyCmd = ''
    mkdir -p ${cfg.directories.plugins}
    cp ${apoc}/share/java/apoc.jar ${cfg.directories.plugins}/apoc.jar
    chown -R neo4j:neo4j ${cfg.directories.plugins}
    chmod 644 ${cfg.directories.plugins}/apoc.jar
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
