{
  pkgs,
  defaults,
  config,
  lib,
  ...
}: let
  wallpaper = pkgs.stdenv.mkDerivation {
    name = "wallpaper";
    src = ./.;

    # https://imagemagick.org/script/gradient.php
    installPhase = ''
      mkdir -p $out
      # ${pkgs.imagemagick}/bin/convert -size ${toString defaults.display.width}x${toString defaults.display.height} -define gradient:angle=45 gradient:#${defaults.colorScheme.palette.base0E}-#${defaults.colorScheme.palette.base06} $out/wallpaper.png
      ${pkgs.imagemagick}/bin/convert -size ${toString defaults.display.width}x${toString defaults.display.height} -define gradient:angle=45 gradient:#${defaults.colorScheme.palette.base0D}-#${defaults.colorScheme.palette.base07} $out/wallpaper.png
      # ${pkgs.imagemagick}/bin/convert -size 1x1 canvas:#${defaults.colorScheme.palette.base04} $out/wallpaper.png
    '';
  };
in {
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";

    image = "${wallpaper}/wallpaper.png";

    # open file:///etc/stylix/palette.html
    base16Scheme = defaults.colorScheme;

    fonts = defaults.fonts;

    cursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Snow";
      # name = "Quintom_Ink";

      # package = pkgs.simp1e-cursors;
      # name = "Simp1e-Adw";
      # name = "Simp1e-Catppuccin-Mocha";
      size = 27;
    };
  };
}
