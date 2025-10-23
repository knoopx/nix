{
  pkgs,
  nixosConfig,
  nix-colors,
  ...
}: let
  palette = nixosConfig.defaults.colorScheme.palette;
  bgPrimaryRgb = nix-colors.lib.conversions.hexToRGB palette.base02;
  bgSecondaryRgb = nix-colors.lib.conversions.hexToRGB palette.base03;
  textPrimaryRgb = nix-colors.lib.conversions.hexToRGB palette.base05;
  textSecondaryRgb = nix-colors.lib.conversions.hexToRGB palette.base04;
  accentPrimaryRgb = nix-colors.lib.conversions.hexToRGB palette.base0D;
  accentSecondaryRgb = nix-colors.lib.conversions.hexToRGB palette.base02;
  successRgb = nix-colors.lib.conversions.hexToRGB palette.base0B;
  warningRgb = nix-colors.lib.conversions.hexToRGB palette.base09;
  errorRgb = nix-colors.lib.conversions.hexToRGB palette.base08;
in {
  home.packages = with pkgs; [
    astal-shell
  ];

  xdg.configFile."astal-shell/displays.json".text = builtins.toJSON {
    "LG HDR 4K" = [390 145];
    "Unknown" = [200 70];
  };

  xdg.configFile."astal-shell/theme.json".text = ''
    {
      "background": {
        "primary": "rgba(${toString (builtins.elemAt bgPrimaryRgb 0)}, ${toString (builtins.elemAt bgPrimaryRgb 1)}, ${toString (builtins.elemAt bgPrimaryRgb 2)}, 0.8)",
        "secondary": "rgba(${toString (builtins.elemAt bgSecondaryRgb 0)}, ${toString (builtins.elemAt bgSecondaryRgb 1)}, ${toString (builtins.elemAt bgSecondaryRgb 2)}, 0.12)"
      },
      "text": {
        "primary": "rgba(${toString (builtins.elemAt textPrimaryRgb 0)}, ${toString (builtins.elemAt textPrimaryRgb 1)}, ${toString (builtins.elemAt textPrimaryRgb 2)}, 1.0)",
        "secondary": "rgba(${toString (builtins.elemAt textSecondaryRgb 0)}, ${toString (builtins.elemAt textSecondaryRgb 1)}, ${toString (builtins.elemAt textSecondaryRgb 2)}, 0.7)",
        "focused": "rgba(${toString (builtins.elemAt textPrimaryRgb 0)}, ${toString (builtins.elemAt textPrimaryRgb 1)}, ${toString (builtins.elemAt textPrimaryRgb 2)}, 1.0)",
        "unfocused": "rgba(${toString (builtins.elemAt textSecondaryRgb 0)}, ${toString (builtins.elemAt textSecondaryRgb 1)}, ${toString (builtins.elemAt textSecondaryRgb 2)}, 0.7)"
      },
      "accent": {
        "primary": "rgba(${toString (builtins.elemAt accentPrimaryRgb 0)}, ${toString (builtins.elemAt accentPrimaryRgb 1)}, ${toString (builtins.elemAt accentPrimaryRgb 2)}, 0.9)",
        "secondary": "rgba(${toString (builtins.elemAt accentSecondaryRgb 0)}, ${toString (builtins.elemAt accentSecondaryRgb 1)}, ${toString (builtins.elemAt accentSecondaryRgb 2)}, 1.0)"
      },
      "status": {
        "success": "rgba(${toString (builtins.elemAt successRgb 0)}, ${toString (builtins.elemAt successRgb 1)}, ${toString (builtins.elemAt successRgb 2)}, 1.0)",
        "warning": "rgba(${toString (builtins.elemAt warningRgb 0)}, ${toString (builtins.elemAt warningRgb 1)}, ${toString (builtins.elemAt warningRgb 2)}, 1.0)",
        "error": "rgba(${toString (builtins.elemAt errorRgb 0)}, ${toString (builtins.elemAt errorRgb 1)}, ${toString (builtins.elemAt errorRgb 2)}, 1.0)"
      }
    }
  '';

  systemd.user.services.astal-shell = {
    Unit = {
      Description = "Astal Shell";
      After = ["graphical-session.target"];
      Wants = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.astal-shell}/bin/astal-shell";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
