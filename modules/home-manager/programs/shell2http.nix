{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.shell2http;
in {
  options.programs.shell2http = {
    enable = mkEnableOption "shell2http, a tool to expose shell commands as HTTP endpoints";
    package = mkOption {
      type = types.package;
      default = pkgs.shell2http;
      description = "The shell2http package to use.";
    };
    args = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Arguments to pass to shell2http.";
    };
    serviceConfig = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra systemd user service options.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    systemd.user.services.shell2http = {
      Unit = {
        Description = "shell2http service";
        After = ["network.target"];
      };
      Service =
        {
          ExecStart = "${cfg.package}/bin/shell2http ${concatStringsSep " " cfg.args}";
          Restart = "on-failure";
        }
        // cfg.serviceConfig;
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
