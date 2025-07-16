{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.llama-swap;
  settingsFormat = pkgs.formats.yaml {};
  configFile = settingsFormat.generate "config.yml" cfg.settings;
in {
  options.services.llama-swap = {
    enable = lib.mkEnableOption "enable the llama-swap service";

    package = lib.mkPackageOption pkgs "llama-swap" {};

    port = lib.mkOption {
      default = 11434;
      type = lib.types.port;
    };

    settings = lib.mkOption {
      type = lib.types.submodule {freeformType = settingsFormat.type;};
      description = ''
        llama-swap configuration. Refer to https://github.com/mostlygeek/llama-swap for details on supported values.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.llama-swap = {
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      description = "llama-swap is a light weight, transparent proxy server that provides automatic model swapping to llama.cpp's server.";
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --listen :${toString cfg.port} --config ${configFile}";
        Restart = "on-failure";
        RestartSec = 3;
        Type = "exec";
        DynamicUser = false;
      };
    };
  };
}
