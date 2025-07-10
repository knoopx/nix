{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.shell2http;
in {
  options.services.shell2http = {
    enable = mkEnableOption "shell2http service";
    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Port to listen on.";
    };
    routes = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Routes to expose, as a set of path = shell command.";
      example = {
        "/date" = "date";
        "/uptime" = "uptime";
      };
    };
    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra arguments to pass to shell2http.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.shell2http = {
      description = "shell2http web server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = let
          routeArgs = lib.concatMapStringsSep " " (path: cmd: ''"${path}:${cmd}"'') (lib.attrNames cfg.routes) (lib.attrValues cfg.routes);
        in ''${shell2httpPkg}/bin/shell2http -port ${toString cfg.port} ${routeArgs} ${lib.concatStringsSep " " cfg.extraArgs}'';
        Restart = "on-failure";
        User = "shell2http";
        Group = "shell2http";
        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
      };
    };
  };
}
