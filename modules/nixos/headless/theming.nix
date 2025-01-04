{
  pkgs,
  defaults,
  ...
}: let
  # params = {
  #   mode = "transformer";
  #   num_colors = 4;
  #   temperature = "1.2";
  #   num_results = 50;
  #   adjacency = [
  #     "0"
  #     "65"
  #     "45"
  #     "35"
  #     "65"
  #     "0"
  #     "35"
  #     "65"
  #     "45"
  #     "35"
  #     "0"
  #     "35"
  #     "35"
  #     "65"
  #     "35"
  #     "0"
  #   ];
  #   palette = ["#cc0000" "#ffff00" "#1a5fb4" "#26a269"];
  # };
  wallpaper = pkgs.stdenvNoCC.mkDerivation {
    name = "wallpaper";
    phases = ["installPhase"];

    # buildInputs = with pkgs; [curl];
    # outputHashAlgo = "sha256";
    # outputHashMode = "recursive";
    # outputHash = "";

    # https://imagemagick.org/script/gradient.php

    # curl -k --header "Content-Type: application/json" --request POST --data '${builtins.toJSON params}' https://api.huemint.com/color
    # ${pkgs.imagemagick}/bin/magick -size ${toString defaults.display.width}x${toString defaults.display.height} -define gradient:angle=45 gradient:#${defaults.colorScheme.palette.base0E}-#${defaults.colorScheme.palette.base06} $out/usr/share/backgrounds/kos.png
    # ${pkgs.imagemagick}/bin/magick -size 1x1 canvas:#${defaults.colorScheme.palette.base04} $out/usr/share/backgrounds/kos.png
    installPhase = ''
      mkdir -p $out/usr/share/backgrounds
      ${pkgs.imagemagick}/bin/magick -size ${toString defaults.display.width}x${toString defaults.display.height} -define gradient:angle=45 gradient:#${defaults.colorScheme.palette.base0D}-#${defaults.colorScheme.palette.base07} $out/usr/share/backgrounds/kos.png
    '';
  };
in {
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";

    image = "${wallpaper}/usr/share/backgrounds/kos.png";

    base16Scheme = defaults.colorScheme;

    fonts = defaults.fonts;

    cursor = {
      package = pkgs.quintom-cursor-theme;
      name = "Quintom_Snow";
      # name = "Quintom_Ink";

      # package = pkgs.simp1e-cursors;
      # name = "Simp1e-Adw";
      # name = "Simp1e-Catppuccin-Mocha";
      size = 24;
    };
  };
}
