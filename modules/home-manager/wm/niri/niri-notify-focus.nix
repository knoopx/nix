{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.programs.niri-notify-focus;
in {
  options.programs.niri-notify-focus = {
    enable = lib.mkEnableOption "niri-notify-focus daemon";

    package = lib.mkPackageOption pkgs "niri-notify-focus" {};

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = with lib.types; let
          effectEnum = enum ["shrink" "expand" "none"];
        in
          attrsOf (oneOf [effectEnum int str]);
        options = {
          effect = lib.mkOption {
            type = lib.types.enum ["shrink" "expand" "none"];
            default = "shrink";
            description = "Visual effect when focusing a window";
          };

          pulse_pixels = lib.mkOption {
            type = lib.types.int;
            default = 50;
            description = "Pixels to shrink/expand during pulse animation";
          };
        };
      };
      default = {};
      description = "niri-notify-focus configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];

    xdg.configFile."niri-notify-focus/config.toml".text = let
      mkLine = name: value: let
        formatted =
          if builtins.isInt value
          then "${name} = ${builtins.toString value}"
          else "${name} = \"${value}\"";
      in
        formatted;
    in
      lib.concatStringsSep "\n" (
        map (name: mkLine name cfg.settings.${name}) (lib.attrNames cfg.settings)
      )
      + "\n";
    xdg.configFile."niri-notify-focus/config.toml".enable = cfg.enable;

    systemd.user.services.niri-notify-focus = {
      Unit.Description = "Focus source window on notification click";
      Service = {
        ExecStart = "${cfg.package}/bin/niri-notify-focus";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
