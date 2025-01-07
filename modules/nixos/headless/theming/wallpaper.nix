{
  lib,
  pkgs,
  defaults,
  ...
}: {
  options.wallpaper.pkg = lib.mkOption {
    default = pkgs.stdenvNoCC.mkDerivation {
      name = "wallpaper.png";
      phases = ["installPhase"];
      installPhase = ''
        ${pkgs.imagemagick}/bin/magick -size ${toString defaults.display.width}x${toString defaults.display.height} -define gradient:angle=45 gradient:#${defaults.colorScheme.palette.base0D}-#${defaults.colorScheme.palette.base07} $out
      '';
    };
  };
}
