{
  lib,
  pkgs,
  defaults,
  ...
}: let
  wallpaper = pkgs.theming.mkSVGPatternWallpaper {
    # style = pkgs.theming.pattern-monster.japanese-pattern-3;
    # style = pkgs.theming.pattern-monster.scales-6;
    # style = pkgs.theming.pattern-monster.cubes-5;
    # style = pkgs.theming.pattern-monster.terrazzo-1;
    # style = pkgs.theming.pattern-monster.sprinkles-1;
    # style = pkgs.theming.pattern-monster.triangles-18;
    style = pkgs.pattern-monster.doodle-1;

    scale = 4;
    colors = with defaults.colorScheme.palette; [
      base01
      base00
      base02
      base03
      base04

      # base0A
      # base08
      # base0C
      # base07
    ];
  };
in {
  options.wallpaper.pkg = lib.mkOption {
    default = pkgs.stdenvNoCC.mkDerivation {
      name = "wallpaper.png";
      phases = ["installPhase"];
      installPhase = ''
        export HOME=$(pwd)
        ${lib.getExe pkgs.firefox} -headless -screenshot --window-size ${toString defaults.display.width},${toString defaults.display.height} "file://${wallpaper}"
        mv screenshot.png $out
      '';
    };
  };
}
