{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.neo4j;
  copyCmds =
    lib.concatMapStringsSep "\n" (plugin: ''
      for f in ${plugin}/share/java/*.jar; do
        install -m644 "$f" ${cfg.directories.plugins}/$(basename "$f")
      done
    '')
    cfg.plugins;
in {
  options.services.neo4j.plugins = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [];
    example = "[ pkgs.neo4j-apoc ]";
    description = "Packages providing Neo4j plugins to install.";
  };

  config = lib.mkIf cfg.enable {
    systemd.services.neo4j.preStart = lib.mkAfter ''
      mkdir -p ${cfg.directories.plugins}
      ${copyCmds}
      chown -R neo4j:neo4j ${cfg.directories.plugins}
    '';
  };
}
