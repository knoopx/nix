{
  lib,
  pkgs,
  defaults,
  ...
}: {
  options.wallpaper.pkg = lib.mkOption {
    default = pkgs.theming.mkSVGPatternWallpaper {
      style = pkgs.pattern-monster.doodle-1;
      scale = 4;
      colors = with defaults.colorScheme.palette; [
        base01
        base00
        base02
        base03
        base04
      ];
    };
  };
}
