{
  nixosConfig,
  pkgs,
  lib,
  ...
}: let
  mkSVGPatternWallpaper = pkgs.callPackage ../../../../builders/theming/mkSVGPatternWallpaper.nix {inherit pkgs lib nixosConfig;};
  wallpaper = mkSVGPatternWallpaper {
    # style = pkgs.pattern-monster.japanese-pattern-2;
    # style = pkgs.pattern-monster.sprinkles-1;
    # style = pkgs.pattern-monster.plaid-pattern-2;
    # style = pkgs.pattern-monster.triangles-21;
    # style = pkgs.pattern-monster.interlocked-hexagons-2;
    style = pkgs.pattern-monster.triangles-18;
    # style = pkgs.pattern-monster.hexagon-7;

    scale = 4;
    colors = with nixosConfig.defaults.colorScheme.palette; [
      base00
      base01
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
