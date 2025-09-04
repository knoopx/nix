{
  nixosConfig,
  pkgs,
  lib,
  ...
}: let
  mkSVGPatternWallpaper = pkgs.callPackage ../../../../builders/theming/mkSVGPatternWallpaper.nix {inherit pkgs lib nixosConfig;};
  wallpaper = mkSVGPatternWallpaper {
    style = pkgs.pattern-monster.zebra;
    scale = 4;
    colors = with nixosConfig.defaults.colorScheme.palette; [
      base01
      base00
      base02
      base03
      # base04
    ];
  };
in {
  systemd.user.services = {
    wallpaper = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };
      Unit = {
        BindTo = ["niri.service"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper}";
        Restart = "on-failure";
      };
    };
  };
}
