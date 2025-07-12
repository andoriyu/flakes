{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.pushover;
in {
  options.programs.pushover = {
    enable = mkEnableOption "Pushover notification client";

    package = mkOption {
      type = types.package;
      default = pkgs.pushover-cli;
      defaultText = literalExpression "pkgs.pushover-cli";
      description = "The Pushover package to use.";
    };

    secretsFile = mkOption {
      type = types.str;
      example = "/run/secrets/pushover-config";
      description = ''
        Path to a file containing Pushover credentials managed by sops-nix.
        This file should export PUSHOVER_TOKEN and PUSHOVER_USER variables.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    # Create config directory
    home.file.".config/pushover/.keep".text = "";

    # Set environment variable for secrets file
    home.sessionVariables = {
      PUSHOVER_CONFIG = cfg.secretsFile;
    };
  };
}
