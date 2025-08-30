{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.services.vicinae;
in {
  options.services.vicinae = {
    enable = mkEnableOption "vicinae launcher daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.vicinae;
      defaultText = literalExpression "vicinae";
      description = "The vicinae package to use.";
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start the vicinae daemon automatically on login.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    systemd.user.services.vicinae = {
      Unit = {
        Description = "Vicinae launcher daemon";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/vicinae server";
        Restart = "on-failure";
        RestartSec = 3;
      };

      Install = mkIf cfg.autoStart {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
