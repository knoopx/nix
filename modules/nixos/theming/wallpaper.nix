{
  lib,
  pkgs,
  defaults,
  ...
}: let
  wallpaper = pkgs.theming.mkSvgPatternWallpaper pkgs.theming.pattern-monster.waves-11 (with defaults.colorScheme.palette; [
    base03
    base04
    base05
  ]);
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
